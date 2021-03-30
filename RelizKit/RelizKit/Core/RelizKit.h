//
//  RelizKit.h
//  RelizKit
//
//  Created by Александр Сенин on 14.10.2020.
//

#import <Foundation/Foundation.h>


#if !defined(__has_include)
    #error "RelizKit.h won't import anything if your compiler doesn't support __has_include. Please \ import the headers individually."
#else
    #if __has_include(<RZEvent/RZEvent.h>)
      #import <RZEvent/RZEvent.h>
    #endif
    #if __has_include(<RZStoreKit/RZStoreKit.h>)
      #import <RZStoreKit/RZStoreKit.h>
    #endif
    #if __has_include(<RZObservableKit/RZObservableKit.h>)
      #import <RZObservableKit/RZObservableKit.h>
    #endif
    #if __has_include(<RZUIPacKit/RZUIPacKit.h>)
      #import <RZUIPacKit/RZUIPacKit.h>
    #endif
    #if __has_include(<RZViewBuilder/RZViewBuilder.h>)
      #import <RZViewBuilder/RZViewBuilder.h>
    #endif
    #if __has_include(<RZDarkModeKit/RZDarkModeKit.h>)
      #import <RZDarkModeKit/RZDarkModeKit.h>
    #endif
#endif
