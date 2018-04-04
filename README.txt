/*******************************************************************
* Important information:
*
* Last updated: 04/03/2018
*
* Version 1.0.10
*   - Fixed a bug with Static Images that caused it to stop updating
*     after switching between several Indexed Images
*   - Added overlay describing IP address assigned during power-up
*   - Added a reset for the USB0 device to restart RNDIS connections
*     that had a tendacy to provide incorrect addresses to connected devices
*
* Version 1.0.01
*   - Restructured how pattern sequences are synchronized to provide better
*     stability for 1-bit and 8-bit pattern sequences.
*   - reduced NUC to 1, increased Static Images to 32 and kept maximum 
*     patterns supported (768 1-bit or 96 8-bit)
*
* (c)2016-2018 Keynote Photonics
*
* These project files should be cloned from a git reposistory using
*   
*      git clone https://github.com/keynotep/lc4500_pem.git
*
* To install the PEM software, please run 
*
*      lc4500_pem/pem_install.sh
*
* A hostname (network id) will be applied during the install. 
* If you don't provide one when prompted, lc4500-pem will be used.
* This may cause some network conflicts if you have multiple boards
* with the same name.
*
* *****************************************************************/
