/**************************************************************************//**
 * @file     startup_ARMCM7.c
 * @brief    CMSIS Core Device Startup File for
 *           ARMCM7 Device
 * @version  V5.3.1
 * @date     04. June 2019
 ******************************************************************************/
/*
 * Copyright (c) 2009-2019 Arm Limited. All rights reserved.
 * Copyright 2019-2022 NXP
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if defined (ARMCM7)
  #include "ARMCM7.h"
#elif defined (ARMCM7_SP)
  #include "ARMCM7_SP.h"
#elif defined (ARMCM7_DP)
  #include "ARMCM7_DP.h"
#else
  #error device not specified!
#endif

/*----------------------------------------------------------------------------
  Exception / Interrupt Handler Function Prototype
 *----------------------------------------------------------------------------*/
typedef void( *pFunc )( void );

/*----------------------------------------------------------------------------
  External References
 *----------------------------------------------------------------------------*/
extern uint32_t __INITIAL_SP;

/*----------------------------------------------------------------------------
  Internal References
 *----------------------------------------------------------------------------*/
void __NO_RETURN Default_Handler(void);
void __NO_RETURN Reset_Handler  (void);

/*----------------------------------------------------------------------------
  Exception / Interrupt Handler
 *----------------------------------------------------------------------------*/
/* Exceptions */
void __NO_RETURN NMI_Handler            (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN HardFault_Handler      (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN MemManage_Handler      (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN BusFault_Handler       (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN UsageFault_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN SVC_Handler            (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN DebugMon_Handler       (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN PendSV_Handler         (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN SysTick_Handler        (void) __attribute__ ((weak, alias("Default_Handler")));

void __NO_RETURN Interrupt0_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt1_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt2_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt3_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt4_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt5_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt6_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt7_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt8_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));
void __NO_RETURN Interrupt9_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));


/*----------------------------------------------------------------------------
  Exception / Interrupt Vector table
 *----------------------------------------------------------------------------*/

#if defined ( __GNUC__ )
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
#endif

extern const pFunc __VECTOR_TABLE[240];
       const pFunc __VECTOR_TABLE[240] __VECTOR_TABLE_ATTRIBUTE = {
  (pFunc)(&__INITIAL_SP),                   /*     Initial Stack Pointer */
  Reset_Handler,                            /*     Reset Handler */
  NMI_Handler,                              /* -14 NMI Handler */
  HardFault_Handler,                        /* -13 Hard Fault Handler */
  MemManage_Handler,                        /* -12 MPU Fault Handler */
  BusFault_Handler,                         /* -11 Bus Fault Handler */
  UsageFault_Handler,                       /* -10 Usage Fault Handler */
  0,                                        /*     Reserved */
  0,                                        /*     Reserved */
  0,                                        /*     Reserved */
  0,                                        /*     Reserved */
  SVC_Handler,                              /*  -5 SVCall Handler */
  DebugMon_Handler,                         /*  -4 Debug Monitor Handler */
  0,                                        /*     Reserved */
  PendSV_Handler,                           /*  -2 PendSV Handler */
  SysTick_Handler,                          /*  -1 SysTick Handler */

  /* Interrupts */
  Interrupt0_Handler,                       /*   0 Interrupt 0 */
  Interrupt1_Handler,                       /*   1 Interrupt 1 */
  Interrupt2_Handler,                       /*   2 Interrupt 2 */
  Interrupt3_Handler,                       /*   3 Interrupt 3 */
  Interrupt4_Handler,                       /*   4 Interrupt 4 */
  Interrupt5_Handler,                       /*   5 Interrupt 5 */
  Interrupt6_Handler,                       /*   6 Interrupt 6 */
  Interrupt7_Handler,                       /*   7 Interrupt 7 */
  Interrupt8_Handler,                       /*   8 Interrupt 8 */
  Interrupt9_Handler                        /*   9 Interrupt 9 */
  /* Interrupts 10 .. 223 are left out */
};

#if defined ( __GNUC__ )
#pragma GCC diagnostic pop
#endif

/*----------------------------------------------------------------------------
  Reset Handler called on controller reset
*----------------------------------------------------------------------------*/
void __NAKED __NO_RETURN Reset_Handler(void)
{
  __EARLY_INIT();

  /* SP initialization is required for S32Debugger when program loaded into RAM by debugger*/
  __set_MSP((uint32_t)&__INITIAL_SP);

  SystemInit();                             /* CMSIS System Initialization */

  __PROGRAM_START();                        /* Enter PreMain (C library entry point) */
}


/*----------------------------------------------------------------------------
  Default Handler for Exceptions / Interrupts
 *----------------------------------------------------------------------------*/
void Default_Handler(void)
{
  while(1);
}
