#!/bin/sh
#
# $Header: sign_webutil.sh 31-dec-2004.13:50:23 asatyana Exp $
#
# sign_webutil.sh
#
# Copyright (c) 2002, 2004, Oracle. All rights reserved.  
#
#   NAME
#      sign_webutil.sh - Sample script to sign frmwebutil.jar and jacob.jar
#   USAGE
#      sign_webutil.sh <jar_file>
#      jar_file : Path of the jar file to be signed. Prefer to use forward
#                 slash instead of back-slash. Otherwise, some characters may
#                 be strangely escaped. e.g. \f may be printed as 'female'
#                 symbol character on some systems.
#   NOTES
#      This script uses keytool and jarsigner utilities, which usually comes
#      along with JDK in its bin directory. These two utilities must be 
#      available in the PATH for this script to work. Otherwise, signing
#      will fail even though the script may show a successful signing.
#
# The following are the Distinguished Names for keytool. You can change them
# to generate your own key.
# CN = Common Name
# OU = Organization Unit
# O  = Organization
# C  = Country code
#
# Certificate settings:
# These are used to generate the initial signing certificate
# Change them to suite your organisation
#
DN_CN="Product Management"
DN_OU="Development Tools"
DN_O=Oracle
DN_C=US
#
# Give your keystore file
KEYSTORE=$HOME/.keystore
#
# If KEYSTORE already exists, old KEYSTORE_PASSWORD for the keystore file must
# be correctly given here. If KEYSTORE does not already exist, any password
# given here will be taken for the new KEYSTORE file to be created.
#
KEYSTORE_PASSWORD=webutilpasswd
#
# Give your alias key here.
#
JAR_KEY=webutil2
#
# Key Password for the given key to be used for signing.
#
JAR_KEY_PASSWORD=webutil2
#
# Number of days before this certificate expires
#
VALIDDAYS=360


#
# Signing script starts here...
#
if test $# -lt 1
then
  echo Jar file name not given for signing. Use
  echo "$0 <jar-file>"
  exit 1
elif test $# -ne 1
then
  echo Incorrect parameters. Use
  echo "$0 <jar-file>"
  exit 1
fi

echo "Generating a self signing certificate for key=$JAR_KEY..."
error_text=`keytool -genkey -dname "CN=$DN_CN, OU=$DN_OU, O=$DN_O, C=$DN_C" \
        -alias $JAR_KEY -keypass $JAR_KEY_PASSWORD -keystore $KEYSTORE \
        -storepass $KEYSTORE_PASSWORD -validity $VALIDDAYS`
# Check for any error
found=`echo "$error_text" | grep -c "already exists"`
isError=`echo "$error_text" | grep -c "error"`

if test $found -ne 0
then
# Let us show this as warning.
  echo "Warning: $JAR_KEY already present in $KEYSTORE"
elif test $isError -ne 0
then
  echo $error_text
else
  echo "...successfully done."
fi

echo "\n"
# Signing the jar
echo "Backing up $1 as $1.old..."
cp -f $1 $1.old
echo "\n"
echo "Signing $1 using key=$JAR_KEY..."
error_text=`jarsigner -keystore $KEYSTORE -storepass $KEYSTORE_PASSWORD -keypass $JAR_KEY_PASSWORD \
          $1 $JAR_KEY`
# Check for any error
if test "$error_text" != ""
then
  echo $error_text
  echo "Signing $1 failed."
else
  echo "...successfully done."
fi

