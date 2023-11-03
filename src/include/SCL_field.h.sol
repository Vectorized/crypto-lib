//********************************************************************************************/
///*
///*     ___                _   _       ___               _         _    _ _    
///*    / __|_ __  ___  ___| |_| |_    / __|_ _ _  _ _ __| |_ ___  | |  (_) |__ 
///*    \__ \ '  \/ _ \/ _ \  _| ' \  | (__| '_| || | '_ \  _/ _ \ | |__| | '_ \
///*   |___/_|_|_\___/\___/\__|_||_|  \___|_|  \_, | .__/\__\___/ |____|_|_.__/
///*                                         |__/|_|           
///*              
///* Copyright (C) 2023 - Renaud Dubois - This file is part of SCL (Smooth CryptoLib) project
///* License: This software is licensed under MIT License                                        
//********************************************************************************************/

pragma solidity >=0.8.19 <0.9.0;


//choose the field to import
import { p, gx, gy, gpow2p128_x, gpow2p128_y, n, pMINUS_2, nMINUS_2, MINUS_1, _HIBIT_CURVE, FIELD_OID } from "@solidity/fields/SCL_secp256r1.sol";

