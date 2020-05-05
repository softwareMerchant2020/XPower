//
//  Constants.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/19/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
/* URL */
let BASE_URL = "http://www.consoaring.com"
let USER_SERVICE_URL = "/UserService.svc/"
let POINT_SERVICE_URL = "/PointService.svc/"
let CHAT_SERVICE_URL = "/ChatService.svc/"

let AUTHENTICATION_PATH = "userauthentication"
let CREATE_ACCOUNT = "CreateUserAccount"
let RESET_PASSWORD = "resetpassword"
let POINTS_TABLE = "pointstable"
let GET_FAVORITE_TASK = "getfavoritetasks"
let SET_FAVORITE_TASK = "setfavoritetask"
let ADD_DEEDS = "adddeeds"
let RECENT_DEEDS = "getrecentdeeds"
let SCHOOL_POINTS = "totalschoolpoints"
let GET_FRIEND_LIST = "getfriendslist"
let GET_FRIEND_REQUEST_LIST = "getfriendrequests"
let RESPOND_TO_REQUEST = "respondfriendrequest"
let ADD_FRIEND_REQUEST = "addfriendrequest"
let CHANGE_PASSWORD = "changepassword"
let TOGGLE_TOUCH_ID = "toggletouchid"
let GET_MESSAGES = "getmessages"
let SEND_MESSAGE = "sendmessage"
let GET_USER_PROGRESS = "getuserprogress"
let GET_DAILY_POINTS = "dailypoints"
let GET_TOTAL_SCHOOL_POINTS = "totalschoolpoints"


let APP_NAME = "XPower"


/*
 LOGIN/SIGNUP KEYS
 */
let USER_NAME = "Username"
let PASSWORD = "Password"
let EMAIL = "Email"
let SCHOOL_NAME = "SchoolName"
let AVATAR = "Avatar"
let AVATAR_IMG_URL = "Avatarimageurl"
let TOUCH_ID_ON = "TouchIdOn"
let FORGET_PASSWORD = "Forgot Password"
let USER_IMG_AVATAR = "UserImageAvatar"
let ACTION_SUBMIT = "Submit"
let ACTION_REQUIRED = "Required"
let ACTION_OK = "Ok"
let ACTION_SIGNUP = "Sign Up"


let MSG_SUCCESS = "Success"
let LOGIN_NO_EMPTY_ALLOWED = "username and password cannot be left empty"
let SIGNUP_NO_EMPTY_ALLOWED = "All Fields are required"

let LOGIN_SUCCESS = "Login Successfull"

let EMAIL_PLACEHOLDER = "Please enter your Email Address"
let SELECT_SCHOOL = "Select School"


let SCHOOL_HAVERFORD = "Haverford"
let MAIL_HAVERFORD = "@haverford.org"

let SCHOOL_AGNES_IRWIN = "Agnes Irwin"
let MAIL_AGNES_IRWIN = "@agnesirwin.org"

let SEARCH_DEEDS_PLACEHOLDER = "Search Deeds"

let SETTINGS_CHANGE_PASSWORD = "Change Password"
let SETTINGS_REPORT = "Report"
let MAIL_NOT_ALLOWED = "The App does not have permission to open mail. Try configuring mail box"

enum menu:String
{
    case home = "Home",points = "Points",score = "Score",friends = "Friends",settings = "Settings",logout = "Logout"
}

// Notification
let NOTIFICATION_TITLE_MESSAGE = "New Message"
let NOTIFICATION_TITLE_REQUEST = "New Friend Request"














