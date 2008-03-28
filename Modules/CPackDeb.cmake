
# CPack script for creating Debian package
# Author: Mathieu Malaterre
#
# http://wiki.debian.org/HowToPackageForDebian

IF(CMAKE_BINARY_DIR)
  MESSAGE(FATAL_ERROR "CPackDeb.cmake may only be used by CPack internally.")
ENDIF(CMAKE_BINARY_DIR)

IF(NOT UNIX)
  MESSAGE(FATAL_ERROR "CPackDeb.cmake may only be used under UNIX.")
ENDIF(NOT UNIX)

# Let's define the control file found in debian package:

# Binary package:
# http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-binarycontrolfiles

# DEBIAN/control
# debian policy enforce lower case for package name
# Package: (mandatory)
IF(NOT CPACK_DEBIAN_PACKAGE_NAME)
  STRING(TOLOWER "${CPACK_PACKAGE_NAME}" CPACK_DEBIAN_PACKAGE_NAME)
ENDIF(NOT CPACK_DEBIAN_PACKAGE_NAME)

# Version: (mandatory)
IF(NOT CPACK_DEBIAN_PACKAGE_VERSION)
  IF(NOT CPACK_PACKAGE_VERSION)
    MESSAGE(FATAL_ERROR "Debian package requires a package version")
  ENDIF(NOT CPACK_PACKAGE_VERSION)
  SET(CPACK_DEBIAN_PACKAGE_VERSION ${CPACK_PACKAGE_VERSION})
ENDIF(NOT CPACK_DEBIAN_PACKAGE_VERSION)

# Architecture: (mandatory)
IF(NOT CPACK_DEBIAN_PACKAGE_ARCHITECTURE)
  # There is no such thing as i686 architecture on debian, you should use i386 instead
  # $ dpkg --print-architecture
  EXECUTE_PROCESS(COMMAND dpkg --print-architecture
    OUTPUT_VARIABLE CPACK_DEBIAN_PACKAGE_ARCHITECTURE)
ENDIF(NOT CPACK_DEBIAN_PACKAGE_ARCHITECTURE)

# have a look at GET_PROPERTY(result GLOBAL PROPERTY ENABLED_FEATURES),
# this returns the successful FIND_PACKAGE() calls, maybe this can help
# Depends:
# You should set: DEBIAN_PACKAGE_DEPENDS
# TODO: automate 'objdump -p | grep NEEDED'
IF(NOT CPACK_DEBIAN_PACKAGE_DEPENDS)
  MESSAGE(STATUS "CPACK_DEBIAN_PACKAGE_DEPENDS not set, the package will have no dependencies.")
ENDIF(NOT CPACK_DEBIAN_PACKAGE_DEPENDS)

# Maintainer: (mandatory)
IF(NOT CPACK_DEBIAN_PACKAGE_MAINTAINER)
  IF(NOT CPACK_PACKAGE_CONTACT)
    MESSAGE(FATAL_ERROR "Debian package requires a maintainer for a package, set CPACK_PACKAGE_CONTACT or CPACK_DEBIAN_PACKAGE_MAINTAINER")
  ENDIF(NOT CPACK_PACKAGE_CONTACT)
  SET(CPACK_DEBIAN_PACKAGE_MAINTAINER ${CPACK_PACKAGE_CONTACT})
ENDIF(NOT CPACK_DEBIAN_PACKAGE_MAINTAINER)

# Description: (mandatory)
IF(NOT CPACK_DEBIAN_PACKAGE_DESCRIPTION)
  IF(NOT CPACK_PACKAGE_DESCRIPTION_SUMMARY)
    MESSAGE(FATAL_ERROR "Debian package requires a summary for a package, set CPACK_PACKAGE_DESCRIPTION_SUMMARY or CPACK_DEBIAN_PACKAGE_DESCRIPTION")
  ENDIF(NOT CPACK_PACKAGE_DESCRIPTION_SUMMARY)
  SET(CPACK_DEBIAN_PACKAGE_DESCRIPTION ${CPACK_PACKAGE_DESCRIPTION_SUMMARY})
ENDIF(NOT CPACK_DEBIAN_PACKAGE_DESCRIPTION)

# Section: (recommended)
IF(NOT CPACK_DEBIAN_PACKAGE_SECTION)
  SET(CPACK_DEBIAN_PACKAGE_SECTION "devel")
ENDIF(NOT CPACK_DEBIAN_PACKAGE_SECTION)

# Priority: (recommended)
IF(NOT CPACK_DEBIAN_PACKAGE_PRIORITY)
  SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
ENDIF(NOT CPACK_DEBIAN_PACKAGE_PRIORITY )

# Recommends:
# You should set: CPACK_DEBIAN_PACKAGE_RECOMMENDS

# Suggests:
# You should set: CPACK_DEBIAN_PACKAGE_SUGGESTS


# For debian source packages:
# debian/control
# http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-sourcecontrolfiles

# .dsc
# http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-debiansourcecontrolfiles

# Builds-Depends:
#IF(NOT CPACK_DEBIAN_PACKAGE_BUILDS_DEPENDS)
#  SET(CPACK_DEBIAN_PACKAGE_BUILDS_DEPENDS
#    "debhelper (>> 5.0.0), libncurses5-dev, tcl8.4"
#  )
#ENDIF(NOT CPACK_DEBIAN_PACKAGE_BUILDS_DEPENDS)
