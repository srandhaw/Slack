//
//  Constants.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 5/30/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool)->()

//Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let TO_AVATAR_PICKER = "toAvatarPicker"
let UNWIND = "unwindToChannel"


//User defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "email"


//url constants
let BASE_URL = "https://slack-clone--.herokuapp.com/v1/"
let REGISTER_URL = "\(BASE_URL)account/register"
let LOGIN_URL = "\(BASE_URL)account/login"
let ADD_URL = "\(BASE_URL)user/add"
let FIND_USER_BY_EMAIL_URL = "\(BASE_URL)user/byEmail/"
let GET_CHANNELS_URL = "\(BASE_URL)channel/"
let GET_MESSAGES_URL = "\(BASE_URL)message/byChannel/"
