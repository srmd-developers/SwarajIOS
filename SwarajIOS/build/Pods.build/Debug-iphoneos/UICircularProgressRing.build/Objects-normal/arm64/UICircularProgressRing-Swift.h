// Generated by Apple Swift version 5.9 (swiftlang-5.9.0.128.108 clang-1500.0.40.1)
#ifndef UICIRCULARPROGRESSRING_SWIFT_H
#define UICIRCULARPROGRESSRING_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#if defined(__OBJC__)
#include <Foundation/Foundation.h>
#endif
#if defined(__cplusplus)
#include <cstdint>
#include <cstddef>
#include <cstdbool>
#include <cstring>
#include <stdlib.h>
#include <new>
#include <type_traits>
#else
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>
#endif
#if defined(__cplusplus)
#if defined(__arm64e__) && __has_include(<ptrauth.h>)
# include <ptrauth.h>
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreserved-macro-identifier"
# ifndef __ptrauth_swift_value_witness_function_pointer
#  define __ptrauth_swift_value_witness_function_pointer(x)
# endif
# ifndef __ptrauth_swift_class_method_pointer
#  define __ptrauth_swift_class_method_pointer(x)
# endif
#pragma clang diagnostic pop
#endif
#endif

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...) 
# endif
#endif
#if !defined(SWIFT_RUNTIME_NAME)
# if __has_attribute(objc_runtime_name)
#  define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
# else
#  define SWIFT_RUNTIME_NAME(X) 
# endif
#endif
#if !defined(SWIFT_COMPILE_NAME)
# if __has_attribute(swift_name)
#  define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
# else
#  define SWIFT_COMPILE_NAME(X) 
# endif
#endif
#if !defined(SWIFT_METHOD_FAMILY)
# if __has_attribute(objc_method_family)
#  define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
# else
#  define SWIFT_METHOD_FAMILY(X) 
# endif
#endif
#if !defined(SWIFT_NOESCAPE)
# if __has_attribute(noescape)
#  define SWIFT_NOESCAPE __attribute__((noescape))
# else
#  define SWIFT_NOESCAPE 
# endif
#endif
#if !defined(SWIFT_RELEASES_ARGUMENT)
# if __has_attribute(ns_consumed)
#  define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
# else
#  define SWIFT_RELEASES_ARGUMENT 
# endif
#endif
#if !defined(SWIFT_WARN_UNUSED_RESULT)
# if __has_attribute(warn_unused_result)
#  define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
# else
#  define SWIFT_WARN_UNUSED_RESULT 
# endif
#endif
#if !defined(SWIFT_NORETURN)
# if __has_attribute(noreturn)
#  define SWIFT_NORETURN __attribute__((noreturn))
# else
#  define SWIFT_NORETURN 
# endif
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA 
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA 
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA 
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif
#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif
#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER 
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility) 
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED_OBJC)
# if __has_feature(attribute_diagnose_if_objc)
#  define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
# else
#  define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
# endif
#endif
#if defined(__OBJC__)
#if !defined(IBSegueAction)
# define IBSegueAction 
#endif
#endif
#if !defined(SWIFT_EXTERN)
# if defined(__cplusplus)
#  define SWIFT_EXTERN extern "C"
# else
#  define SWIFT_EXTERN extern
# endif
#endif
#if !defined(SWIFT_CALL)
# define SWIFT_CALL __attribute__((swiftcall))
#endif
#if !defined(SWIFT_INDIRECT_RESULT)
# define SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#endif
#if !defined(SWIFT_CONTEXT)
# define SWIFT_CONTEXT __attribute__((swift_context))
#endif
#if !defined(SWIFT_ERROR_RESULT)
# define SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#endif
#if defined(__cplusplus)
# define SWIFT_NOEXCEPT noexcept
#else
# define SWIFT_NOEXCEPT 
#endif
#if !defined(SWIFT_C_INLINE_THUNK)
# if __has_attribute(always_inline)
# if __has_attribute(nodebug)
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline)) __attribute__((nodebug))
# else
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline))
# endif
# else
#  define SWIFT_C_INLINE_THUNK inline
# endif
#endif
#if defined(_WIN32)
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL __declspec(dllimport)
#endif
#else
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL 
#endif
#endif
#if defined(__OBJC__)
#if __has_feature(objc_modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreFoundation;
@import UIKit;
#endif

#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#pragma clang diagnostic ignored "-Wdollar-in-identifier-extension"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="UICircularProgressRing",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

#if defined(__OBJC__)

@class UIColor;
@class UIFont;
@class NSCoder;

/// <h1>UICircularRing</h1>
/// This is the base class of <code>UICircularProgressRing</code> and <code>UICircularTimerRing</code>.
/// You should not instantiate this class, instead use one of the concrete classes provided
/// or subclass and make your own.
/// This is the UIView subclass that creates and handles everything
/// to do with the circular ring.
/// This class has a custom CAShapeLayer (<code>UICircularRingLayer</code>) which
/// handels the drawing and animating of the view
/// <h2>Author</h2>
/// Luis Padron
IB_DESIGNABLE
SWIFT_CLASS("_TtC22UICircularProgressRing14UICircularRing")
@interface UICircularRing : UIView
/// Whether or not the progress ring should be a full circle.
/// What this means is that the outer ring will always go from 0 - 360 degrees and
/// the inner ring will be calculated accordingly depending on current value.
/// <h2>Important</h2>
/// Default = true
/// When this property is true any value set for <code>endAngle</code> will be ignored.
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable BOOL fullCircle;
/// A toggle for showing or hiding the value label.
/// If false the current value will not be shown.
/// <h2>Important</h2>
/// Default = true
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable BOOL shouldShowValueText;
/// A toggle for showing or hiding the value knob when current value == minimum value.
/// If false the value knob will not be shown when current value == minimum value.
/// <h2>Important</h2>
/// Default = false
/// <h2>Author</h2>
/// Tom Knapen
@property (nonatomic) IBInspectable BOOL shouldDrawMinValueKnob;
/// The start angle for the entire progress ring view.
/// Please note that Cocoa Touch uses a clockwise rotating unit circle.
/// I.e: 90 degrees is at the bottom and 270 degrees is at the top
/// <h2>Important</h2>
/// Default = 0 (degrees)
/// Values should be in degrees (they’re converted to radians internally)
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat startAngle;
/// The end angle for the entire progress ring
/// Please note that Cocoa Touch uses a clockwise rotating unit circle.
/// I.e: 90 degrees is at the bottom and 270 degrees is at the top
/// <h2>Important</h2>
/// Default = 360 (degrees)
/// Values should be in degrees (they’re converted to radians internally)
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat endAngle;
/// The width of the outer ring for the progres bar
/// <h2>Important</h2>
/// Default = 10.0
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat outerRingWidth;
/// The color for the outer ring
/// <h2>Important</h2>
/// Default = UIColor.gray
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic, strong) IBInspectable UIColor * _Nonnull outerRingColor;
/// The width of the inner ring for the progres bar
/// <h2>Important</h2>
/// Default = 5.0
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat innerRingWidth;
/// The color of the inner ring for the progres bar
/// <h2>Important</h2>
/// Default = UIColor.blue
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic, strong) IBInspectable UIColor * _Nonnull innerRingColor;
/// The spacing between the outer ring and inner ring
/// <h2>Important</h2>
/// This only applies when using <code>ringStyle</code> = <code>.inside</code>
/// Default = 1
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat innerRingSpacing;
/// The text color for the value label field
/// <h2>Important</h2>
/// Default = UIColor.black
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic, strong) IBInspectable UIColor * _Nonnull fontColor;
/// The font to be used for the progress indicator.
/// All font attributes are specified here except for font color, which is done
/// using <code>fontColor</code>.
/// <h2>Important</h2>
/// Default = UIFont.systemFont(ofSize: 18)
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic, strong) IBInspectable UIFont * _Nonnull font;
/// The direction the circle is drawn in
/// Example: true -> clockwise
/// <h2>Important</h2>
/// Default = true (draw the circle clockwise)
/// <h2>Author</h2>
/// Pete Walker
@property (nonatomic) IBInspectable BOOL isClockwise;
/// Overrides the default layer with the custom UICircularRingLayer class
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) Class _Nonnull layerClass;)
+ (Class _Nonnull)layerClass SWIFT_WARN_UNUSED_RESULT;
/// Overriden public init to initialize the layer and view
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
/// Overriden public init to initialize the layer and view
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/// Overriden because of custom layer drawing in UICircularRingLayer
- (void)drawRect:(CGRect)rect;
@end


SWIFT_CLASS("_TtC22UICircularProgressRing22UICircularProgressRing")
@interface UICircularProgressRing : UICircularRing
/// The value property for the progress ring.
/// <h2>Important</h2>
/// Default = 0
/// Must be a non-negative value. If this value falls below <code>minValue</code> it will be
/// clamped and set equal to <code>minValue</code>.
/// This cannot be used to get the value while the ring is animating, to get
/// current value while animating use <code>currentValue</code>.
/// The current value of the progress ring after animating, use startProgress(value:)
/// to alter the value with the option to animate and have a completion handler.
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat value;
/// The minimum value for the progress ring. ex: (0) -> 100.
/// <h2>Important</h2>
/// Default = 100
/// Must be a non-negative value, the absolute value is taken when setting this property.
/// The <code>value</code> of the progress ring must NOT fall below <code>minValue</code> if it does the <code>value</code> property is clamped
/// and will be set equal to <code>value</code>, you will receive a warning message in the console.
/// Making this value greater than
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat minValue;
/// The maximum value for the progress ring. ex: 0 -> (100)
/// <h2>Important</h2>
/// Default = 100
/// Must be a non-negative value, the absolute value is taken when setting this property.
/// Unlike the <code>minValue</code> member <code>value</code> can extend beyond <code>maxValue</code>. What happens in this case
/// is the inner ring will do an extra loop through the outer ring, this is not noticible however.
/// <h2>Author</h2>
/// Luis Padron
@property (nonatomic) IBInspectable CGFloat maxValue;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end





SWIFT_CLASS("_TtC22UICircularProgressRing19UICircularTimerRing")
@interface UICircularTimerRing : UICircularRing
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


#endif
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#if defined(__cplusplus)
#endif
#pragma clang diagnostic pop
#endif
