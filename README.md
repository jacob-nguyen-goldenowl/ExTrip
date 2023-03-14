![GitHub Cards Preview](Docs/cover.png)

# ExTrip

<span><img src="https://img.shields.io/badge/Swift-282C34?logo=swift&logoColor=F05138" alt="Swift logo" title="Swift" height="25" /></span>
&nbsp;
<span><img src="https://img.shields.io/badge/Firebase-282C34?logo=firebase&logoColor=##FFCA28" alt="Firebase logo" title="Firebase" height="25" /></span>
&nbsp;

A simple travel app for booking hotels for iOS. *Made by [Jacob](https://github.com/jacob-nguyen-goldenowl)*

## UI Design 

<br />

***Click to View Extrip app Design from below 👇***

[![ExTrip]](https://www.figma.com/file/FfvKrAkefsdYNvYlPAZaYu/Trip-Go-Travel-UI-Kit-(Community)?node-id=0%3A2419&t=ttzrCNvNkCMJVNu0-0)

<br />

## Screenshot

| Home                                  | WishList                                  | Booking Tracker                             | Destination                                  | Detail                                  |
| ------------------------------------- | ---------------------------------------- | ------------------------------------- | ------------------------------------ | --------------------------------------- |
| ![](Docs/Screenshots/home_framed.png) | ![](Docs/Screenshots/wishlist_framed.png) | ![](Docs/Screenshots/select_room_framed.png) | ![](Docs/Screenshots/destination_framed.png) | ![](Docs/Screenshots/hotel_detail_framed.png) |

| Booking Room                                  | Review and Book                                  | Room                                  | Payment                                  | Confirm payment                                  |
| ------------------------------------------ | ------------------------------------------------ | --------------------------------------- | ---------------------------------------- | ------------------------------------- |
| ![](Docs/Screenshots/hotel_booking_framed.png) | ![](Docs/Screenshots/review_book_framed.png) | ![](Docs/Screenshots/room.png) | ![](Docs/Screenshots/payment_method_framed.png) | ![](Docs/Screenshots/confirm.png) |

| Profile                                 | Search                                  | View all                                   | Filter                               | Select date                                     |
| ---------------------------------------- | -------------------------------------- | ------------------------------------------- | --------------------------------------- | ------------------------------------------ |
| ![](Docs/Screenshots/profile_framed.png) | ![](Docs/Screenshots/search_city_framed.png) | ![](Docs/Screenshots/view_all_framed.png) | ![](Docs/Screenshots/filter_framed.png) | ![](Docs/Screenshots/select_date_framed.png) |

<br />

## Structure

├── ExTrip
│   ├── AppDelegate
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Base
│   │   └── ETTableViewCell.swift
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── Common
│   │   ├── AsyncImageView.swift
│   │   └── ImageCache.swift
│   ├── Constant
│   │   ├── Tag.swift
│   │   └── UserDefaultKey.swift
│   ├── Controllers
│   │   ├── Auth
│   │   ├── Booking
│   │   ├── Destination
│   │   ├── Detail
│   │   ├── Favorite
│   │   ├── Filter
│   │   ├── Home
│   │   ├── HotelBooking
│   │   ├── More
│   │   └── Profile
│   ├── Customs
│   │   ├── ButtonStyle
│   │   ├── ETGradientButton.swift
│   │   ├── ETIconButton.swift
│   │   ├── ETSearchTextField.swift
│   │   ├── ETTextField.swift
│   │   ├── Label
│   │   ├── Like
│   │   └── Slider
│   ├── Extensions
│   │   ├── Date+Extension.swift
│   │   ├── String+Extension.swift
│   │   ├── UIFont+Extension.swift
│   │   ├── UIImage+Extension.swift
│   │   ├── UILabel+Extension.swift
│   │   ├── UINavigation+Extension.swift
│   │   ├── UIStackView+Extension.swift
│   │   ├── UIView+Extension.swift
│   │   └── UIViewController+Extension.swift
│   ├── Framework
│   │   └── Calender
│   ├── GoogleService-Info.plist
│   ├── Info.plist
│   ├── Model
│   │   ├── BookingModel.swift
│   │   ├── DestinationModel.swift
│   │   ├── FilterModel.swift
│   │   ├── HotelBookingModel.swift
│   │   ├── HotelModel.swift
│   │   ├── OnboardingModel.swift
│   │   ├── RoomBookingModel.swift
│   │   ├── RoomModel.swift
│   │   ├── StepBookingModel.swift
│   │   └── UserInfoModel.swift
│   ├── Navigation
│   │   └── TabbarViewController.swift
│   ├── Networking
│   │   ├── AuthManager.swift
│   │   ├── DatabaseBooking.swift
│   │   ├── DatabaseManager.swift
│   │   ├── DatabaseRequest.swift
│   │   ├── DatabaseResponse.swift
│   │   ├── StatusCode.swift
│   │   └── UserManager.swift
│   ├── Observable
│   │   └── Observable.swift
│   ├── Resources
│   │   ├── Assets.xcassets
│   │   ├── Colors
│   │   └── Fonts
│   ├── ViewModel
│   │   ├── BookingViewModel.swift
│   │   ├── FilterViewModel.swift
│   │   ├── HomeViewModel.swift
│   │   ├── HotelViewModel.swift
│   │   ├── SearchViewModel.swift
│   │   ├── SignInViewModel.swift
│   │   └── SignUpViewModel.swift
│   └── Views
│       ├── Error
│       ├── Header
│       ├── Loading
│       ├── Onboarding
│       ├── Ratting
│       └── Search
├── ExTrip.xcodeproj

<br />

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Cocoapods 1.12.0

<br />

## Installation
​
### Github Repo

You can pull the *[Extrip Git Repo](https://github.com/jacob-nguyen-goldenowl/ExTrip.git)* and go to project folder

### CocoaPods

Install pod dependencies to your project:

```
pod install
```  

## Usage

1. Open Extrip.xcworkspace and run​

2. Login with account
    - Test account: Test@gmail.com
    - Password: 123456

## Built With 

- UI Libraries

  - [JTAppleCalendar](https://github.com/patchthecode/JTAppleCalendar.git) -  Swift calendar Library. iOS calendar Control .
  - [Lottie](https://github.com/airbnb/lottie-ios) - An iOS library to natively render After Effects vector animations.
  - [Cosmos](https://github.com/evgenyneu/Cosmos.git) - A star rating control for iOS/tvOS written in Swift.
  - [AORangeSlider](https://github.com/Andy1984/AORangeSlider.git)  - AORangeSlider is a custom UISlider with two handlers to pick a minimum and a maximum range.
  
- Logics Libraries
  - [SwiftLint](https://github.com/realm/SwiftLint.git) - A tool to enforce Swift style and conventions.  

<br />

## UI References
- https://github.com/simla-tech/Fastis
- https://github.com/Shadberrow/YVTextField
- https://github.com/zoonooz/ZFRippleButton

<br />

## Resources

- https://icons8.com/
- https://lottiefiles.com/
- https://www.canva.com/

