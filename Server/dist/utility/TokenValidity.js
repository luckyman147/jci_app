"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateSecureKey = exports.validateSuperAdminSignature = exports.validateAdminSignature = exports.validateSignature = exports.generateRefreshToken = exports.generateAccessToken = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const Member_1 = require("../models/Member");
const verification_1 = require("./verification");
require('dotenv').config();
const generateAccessToken = (payload) => __awaiter(void 0, void 0, void 0, function* () {
    // Ensure APP_SECRET is defined
    if (!process.env.APP_SECRET) {
        throw new Error('APP_SECRET environment variable is not defined');
    }
    const accessToken = jsonwebtoken_1.default.sign(payload, process.env.APP_SECRET, {
        expiresIn: '20h',
    });
    if (!(yield (0, verification_1.isAccessTokenValid)(payload._id, accessToken))) {
        yield (0, exports.generateAccessToken)(payload);
    }
    return {
        accessToken
    };
});
exports.generateAccessToken = generateAccessToken;
const generateRefreshToken = (payload) => __awaiter(void 0, void 0, void 0, function* () {
    // Ensure APP_SECRET is defined
    if (!process.env.APP_SECRET) {
        throw new Error('APP_SECRET environment variable is not defined');
    }
    const refreshToken = jsonwebtoken_1.default.sign(payload, process.env.APP_SECRET, {
        expiresIn: '1d',
    });
    if (!(yield (0, verification_1.isRefreshTokenValid)(payload.email, refreshToken))) {
        const member = yield Member_1.Member.findOne({ email: payload.email });
        if (member) {
            yield (0, exports.generateAccessToken)({
                _id: member._id,
                email: member.email,
                role: member.role
            });
        }
    }
    return {
        refreshToken
    };
});
exports.generateRefreshToken = generateRefreshToken;
const validateSignature = (req) => __awaiter(void 0, void 0, void 0, function* () {
    if (!process.env.APP_SECRET) {
        throw new Error('APP_SECRET environment variable is not defined');
    }
    const signature = req.get('Authorization');
    if (signature) {
        try {
            const payload = jsonwebtoken_1.default.verify(signature.split(' ')[1], process.env.APP_SECRET);
            const check = yield (0, verification_1.isAccessTokenValid)(payload._id, signature);
            console.log("check", check);
            if (check) {
                req.member = payload;
                return true;
            }
            return false;
        }
        catch (_a) {
            console.log('error');
        }
    }
    return false;
});
exports.validateSignature = validateSignature;
const validateAdminSignature = (req) => __awaiter(void 0, void 0, void 0, function* () {
    const signature = req.get('Authorization');
    if (signature) {
        console.log('signature', signature);
        const payload = jsonwebtoken_1.default.verify(signature.split(' ')[1], process.env.APP_SECRET);
        console.log('payload', payload);
        req.member = payload;
        return true;
    }
    return false;
});
exports.validateAdminSignature = validateAdminSignature;
const validateSuperAdminSignature = (req) => __awaiter(void 0, void 0, void 0, function* () {
    const signature = req.get('Authorization');
    if (signature) {
        const payload = jsonwebtoken_1.default.verify(signature.split(' ')[1], process.env.APP_SECRET);
        req.superadmin = payload;
        return true;
    }
    return false;
});
exports.validateSuperAdminSignature = validateSuperAdminSignature;
const generateSecureKey = () => {
    const characters = process.env.APP_SECRET;
    let key = '';
    for (let i = 0; i < 5; i++) {
        const randomIndex = Math.floor(Math.random() * characters.length);
        key += characters.charAt(randomIndex);
    }
    return key;
};
exports.generateSecureKey = generateSecureKey;
