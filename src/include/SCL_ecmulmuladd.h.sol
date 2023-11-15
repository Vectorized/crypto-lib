/********************************************************************************************/
/*
/*     ___                _   _       ___               _         _    _ _    
/*    / __|_ __  ___  ___| |_| |_    / __|_ _ _  _ _ __| |_ ___  | |  (_) |__ 
/*    \__ \ '  \/ _ \/ _ \  _| ' \  | (__| '_| || | '_ \  _/ _ \ | |__| | '_ \
/*   |___/_|_|_\___/\___/\__|_||_|  \___|_|  \_, | .__/\__\___/ |____|_|_.__/
/*                                         |__/|_|           
/*              
/* Copyright (C) 2023 - Renaud Dubois - This file is part of SCL (Smooth CryptoLib) project
/* License: This software is licensed under MIT License                                        
/********************************************************************************************/
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { p, gx, gy, n, pMINUS_2, nMINUS_2 } from "@solidity/include/SCL_field.h.sol";
import { ec_Aff_Add} from "@solidity/include/SCL_elliptic.h.sol";


//curves with a=-3 coefficients
//import { ec_mulmuladdX} from "@solidity/elliptic/SCL_mulmuladd_am3_inlined.sol";

import { ec_mulmuladdX} from "@solidity/elliptic/SCL_mulmuladd_a1_inlined.sol";


//choose one of those for b4 mulmuladd with 6 arguments:
//import { ec_mulmuladdX_noasm as ec_mulmuladdX} from "@solidity/elliptic/SCL_mulmuladd_am3_b4_noasm.sol";
import {ec_mulmuladdX_asm as ec_mulmuladdX} from "@solidity/elliptic/SCL_mulmuladd_am3_b4_inlined.sol";

import{ec_mulmuladd_S8_extcode}  from "@solidity/elliptic/SCL_mulmuladd_prec_inlined.sol";


