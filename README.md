STM32f4 Gamepad
===============

This is my USB firmware for the stm32f4-discovery board. It is based on the mouse example provided by ST by modifying the [usbd_hid_core.c](https://github.com/guitarfriiik/stm32f4_Gamepad/blob/master/usbd_hid_core.c) and overriding the original file at *$STM_SRC_DIR/Libraries/STM32_USB_Device_Library/Class/hid/usbd_hid_core.c*. Since it is using the HID class sources there is no need for extra drivers when running OS X / Linux. In this example I am using a Sega Genesis controller connected to GPIOA.

Compilation
-----------
Download and install the following software for your platform
  * The gcc-arm-none-eabi toolchain.
  * openOCD.
  * st-link (optional)
  * The stm32f4 firmware - [Download from ST](http://www.st.com/web/en/catalog/tools/PF257904#)
  * Specify the folder of the firmware in the Makefile and run make.
  * Upload the resuling binary to the board using openOCD or st-link.

Usage
-----
Simply connect the board using both USB ports. The mini USB is used for supplying the board with power and the micro for sending the HID reports to the PC.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=YOUTUBE_VIDEO_ID_HERE
" target="_blank"><img src="http://img.youtube.com/vi/ZgL-Va6dkrA/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

Troubleshooting
---------------
Sometimes the USB will not be recognized after reprogramming the board a number of times. In these situations it is sufficient to perform a mass erase of the flash using either st-link or openOCD.  

