/********************************************************************************************/
/*
/*   ╔═╗╔╦╗╔═╗╔═╗╔╦╗╦ ╦  ╔═╗╦═╗╦ ╦╔═╗╔╦╗╔═╗╦  ╦╔╗ 
/*   ╚═╗║║║║ ║║ ║ ║ ╠═╣  ║  ╠╦╝╚╦╝╠═╝ ║ ║ ║║  ║╠╩╗
/*   ╚═╝╩ ╩╚═╝╚═╝o╩ ╩ ╩  ╚═╝╩╚═ ╩ ╩   ╩ ╚═╝╩═╝╩╚═╝
/*              
/* Copyright (C) 2024 - Renaud Dubois - This file is part of SCL (Smoo.th CryptoLib) project
/* License: This software is licensed under MIT License (and allways will)   
/* Description: This file implements the eddsa verification protocol over secp256r1 as specified by RFC8032.                       
/********************************************************************************************/
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;


import "@solidity/hash/SCL_sha512.sol";

import  "@solidity/modular/SCL_ModInv.sol"; 
import "@solidity/fields/SCL_wei25519.sol";
import "@solidity/elliptic/SCL_Isogeny.sol";

import "@solidity/lib/libSCL_ripB4.sol";


//5.1.5.  Key Generation


//the name of the library 
library SCL_EDDSA{
 
 function ecPow128(uint256 X, uint256 Y, uint256 ZZ, uint256 ZZZ) public returns(uint256 x128, uint256 y128){
   assembly{
   function vecDbl(x, y, zz, zzz) -> _x, _y, _zz, _zzz{
            let T1 := mulmod(2, y, p) //U = 2*Y1, y free
                let T2 := mulmod(T1, T1, p) // V=U^2
                let T3 := mulmod(x, T2, p) // S = X1*V
                T1 := mulmod(T1, T2, p) // W=UV
                let T4 := addmod(mulmod(3, mulmod(x,x,p),p),mulmod(a,mulmod(zz,zz,p),p),p)//M=3*X12+aZZ12  
                _zzz := mulmod(T1, zzz, p) //zzz3=W*zzz1
                _zz := mulmod(T2, zz, p) //zz3=V*ZZ1

                _x := addmod(mulmod(T4, T4, p), mulmod(pMINUS_2, T3, p), p) //X3=M^2-2S
                T2 := mulmod(T4, addmod(_x, sub(p, T3), p), p) //-M(S-X3)=M(X3-S)
                _y := addmod(mulmod(T1, y, p), T2, p) //-Y3= W*Y1-M(S-X3), we replace Y by -Y to avoid a sub in ecAdd
                _y:= sub(p, _y)
         }
         for {x128:=0} lt(x128, 128) { x128:=add(x128,1) }{
           X, Y, ZZ, ZZZ := vecDbl(X, Y, ZZ, ZZZ)
         }
         }
      ZZ=ModInv(ZZ, p);
      ZZZ=ModInv(ZZZ,p);
      x128=mulmod(X, ZZ, p);
      y128=mulmod(Y, ZZZ, p);
}

 function BasePointMultiply(uint256 scalar) internal returns (uint256[2] memory R) {
    uint256 [10] memory Q=[0,0,0,0, p, a, gx, gy, gpow2p128_x, gpow2p128_y ];////store Qx, Qy, Q'x, Q'y , p, a, gx, gy, gx2pow128, gy2pow128 
    //abusing RIPB4 for base point multiplication
    R=SCL_RIPB4.ecMulMulAdd_B4(Q, scalar, 0);

 }

 function HashSecret(uint256 secret) public pure returns (uint256 expanded){
   uint64[16] memory buffer; 
   
 
   uint256 low;
   uint256 high;

   buffer[0]=uint64((secret>>192)&0xffffffffffffffff);
   buffer[1]=uint64((secret>>128)&0xffffffffffffffff);
   buffer[2]=uint64((secret>>64)&0xffffffffffffffff);
   buffer[3]=uint64(secret&0xffffffffffffffff);

/*
   buffer[0]=uint64((secret)&0xffffffffffffffff);
   buffer[1]=uint64((secret>>64)&0xffffffffffffffff);
   buffer[2]=uint64((secret>>128)&0xffffffffffffffff);
   buffer[3]=uint64((secret>>192)&0xffffffffffffffff);
*/

   buffer[4]=uint64(0x80)<<56;
   buffer[15]=0x100;//length is 256 bits

   (low,high)=SCL_sha512.SHA512(buffer);
    expanded=low;
    
    expanded=SCL_sha512.Swap256(expanded);
  expanded &= (1 << 254) - 8;
   expanded |= (1 << 254);

    return expanded;
 }

 //function exposed for RFC8032 compliance, but SetKey is more efficient
 function ExpandSecret(uint256 secret) public returns (uint256[2] memory Kpub)
 {
   
   secret=HashSecret(secret);
 
   Kpub=BasePointMultiply(secret);
   (Kpub[0], Kpub[1])=WeierStrass2Edwards(Kpub[0], Kpub[1]);

 }

 //eddsa benefit from the 255 bits to compress the parity of y in msb bit
 function edCompress(uint256[2] memory Kpub) public returns(uint256 KPubC){
  KPubC=Kpub[0] +((Kpub[1]&1)<<255) ;

  return KPubC;
 }

 function edDecompress() internal returns (uint256[2] memory Kpub){

 }
 
 function SetKey(uint256 secret) public returns (uint256[2] memory Kpub)
 {

 }

 //Rs is the 
 function Verify(bytes memory msg, uint256 r, uint256 s, uint256[4] memory extKpub) public returns(bool flag){
   uint256 A=edCompress(Kpub);
   uint256 k;
   uint64[16] memory tampon;
   uint256[2] memory S;
   //todo: add parameters checking
   tampon=SCL_sha512.eddsa_sha512(r,A,msgo);
   (S[0], S[1]) = SCL_sha512.SHA512(tampon);
   k= SCL_sha512.Swap512(S); //endianness curse

   uint256 [10] memory Q=[Q[0], Q[1],Q[2], Q[3], p, a, gx, gy, gpow2p128_x, gpow2p128_y ];

   //3.  Check the group equation [8][S]B = [8]R + [8][k]A'.  It's sufficient, 
   //but not required, to instead check [S]B = R + [k]A'.
   //SCL tweak equality to substraction to check [S]B - [k]A' = [S]B + [n-k]A' = R 
   S=SCL_RIPB4.ecMulMulAdd_B4(Q, s, n-k);
   
   return(S[0]==r);    

 }

}
