//
//  RelizKit.h
//  RelizKit
//
//  Created by Александр Сенин on 14.10.2020.
//

#import <Foundation/Foundation.h>

//! Project version number for RelizKit.
FOUNDATION_EXPORT double RelizKitVersionNumber;

//! Project version string for RelizKit.
FOUNDATION_EXPORT const unsigned char RelizKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RelizKit/PublicHeader.h>

#import <UIKit/UIKit.h>
#if __has_include(<RZDarkModeKit/RZDarkModeKit.h>)
  #import <RZDarkModeKit/RZDarkModeKit.h>
#endif
