"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CheckPermission = exports.revokeAccessToken = exports.revokeRefreshToken = exports.isAccessTokenValid = exports.isRefreshTokenValid = exports.VerifyrefreshToken = void 0;
const jsonwebtoken_1 = __importStar(require("jsonwebtoken"));
const Member_1 = require("../models/Member");
const TokenValidity_1 = require("./TokenValidity");
require('dotenv').config();
const VerifyrefreshToken = (refrecshToken) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const payload = jsonwebtoken_1.default.verify(refrecshToken, process.env.APP_SECRET);
        if (payload) {
            if (!(yield (0, exports.isRefreshTokenValid)(payload.email, refrecshToken))) {
                return { message: 'refresh revoked', accessToken: '' };
            }
            const { accessToken } = yield (0, TokenValidity_1.generateAccessToken)({
                email: payload.email,
                _id: payload._id,
                role: payload.role
            });
            return { message: 'refresh success', accessToken, refreshToken: refrecshToken };
        }
        else {
            return { message: 'refresh error', accessToken: '' };
        }
    }
    catch (e) {
        if (e instanceof jsonwebtoken_1.TokenExpiredError) {
            return { message: 'refresh expired', accessToken: '' };
        }
    }
    return { message: 'something wrong', accessToken: '' };
});
exports.VerifyrefreshToken = VerifyrefreshToken;
const isRefreshTokenValid = (email, refreshToken) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = yield Member_1.Member.findOne({ email: email });
        if (user)
            // Check if the refresh token is not in the list of revoked tokens
            return !user.refreshTokenRevoked.includes(refreshToken);
    }
    catch (error) {
        console.log('Error checking refresh token validity:', error);
        return false;
    }
});
exports.isRefreshTokenValid = isRefreshTokenValid;
const isAccessTokenValid = (userId, AccessToken) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = yield Member_1.Member.findById(userId);
        if (user)
            return !user.accessTokenRevoked.includes(AccessToken);
    }
    catch (error) {
        console.log('Error checking Access token validity:', error);
        return false;
    }
});
exports.isAccessTokenValid = isAccessTokenValid;
const revokeRefreshToken = (email, userId, refreshToken, accesstoken) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = yield Member_1.Member.findById(email);
        if (user) {
            const check = (yield (0, exports.isRefreshTokenValid)(email, refreshToken)) && (yield (0, exports.isAccessTokenValid)(userId, accesstoken));
            console.log("hey  there", check);
            if (check) {
                user.refreshTokenRevoked = user.refreshTokenRevoked || [];
                user.accessTokenRevoked = user.accessTokenRevoked || [];
                // Add the refresh token to the list of revoked tokens
                user.accessTokenRevoked.push(accesstoken);
                user.refreshTokenRevoked.push(refreshToken);
                // Save the updated user object to the database
                yield user.save();
                return { message: 'Logout successful' };
            }
            else {
                return { message: 'Already logged in' };
            }
        }
    }
    catch (error) {
        return { message: "Error revoking refresh token" };
    }
});
exports.revokeRefreshToken = revokeRefreshToken;
const revokeAccessToken = (userId, AccessToken) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = yield Member_1.Member.findById(userId);
        const check = yield (0, exports.isAccessTokenValid)(userId, AccessToken);
        console.log("hey  there", check);
        if (user) {
            // Add the refresh token to the list of revoked tokens
            user.accessTokenRevoked.push(AccessToken);
            // Save the updated user object to the database
            yield user.save();
        }
    }
    catch (error) {
        console.error('Error revoking Access token:', error);
    }
});
exports.revokeAccessToken = revokeAccessToken;
const CheckPermission = (PermissionId, PermissionsIds) => __awaiter(void 0, void 0, void 0, function* () {
    return PermissionsIds.includes(PermissionId);
});
exports.CheckPermission = CheckPermission;
