/* -----------------------------------------------------------------------------
 * Copyright (c) 2020 Arm Limited (or its affiliates). All rights reserved.
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
 * -------------------------------------------------------------------------- */

#include <stdio.h>
#include <stdint.h>
#include "device_cfg.h"
#include "Driver_USART.h"

extern ARM_DRIVER_USART Driver_USART0;

void stdio_init (void) {
  Driver_USART0.Initialize(NULL);
  Driver_USART0.Control(ARM_USART_MODE_ASYNCHRONOUS, 115200U);
}

/**
  Put a character to the stdout

  \param[in]   ch  Character to output
  \return          The character written, or -1 on write error.
*/
int stdout_putchar (int ch) {
  int32_t ret;

#ifdef __UVISION_VERSION
  // Windows Telnet expects CR-LF line endings
  // add carriage return before each line feed
  if (ch=='\n') {
    int cr = '\r';
    Driver_USART0.Send(&cr, 1U);
  }
#endif

  if (Driver_USART0.Send(&ch, 1U) == ARM_DRIVER_OK) {
    return ch;
  }
  return EOF;
}
