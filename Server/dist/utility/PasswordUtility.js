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
exports.validateSuperAdminSignature = exports.validateAdminSignature = exports.validateSignature = exports.generateSignature = exports.ValidatePassword = exports.HashPassword = exports.GenerateSalt = void 0;
const bcrypt_1 = __importDefault(require("bcrypt"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const role_1 = require("../models/role");
require('dotenv').config();
const GenerateSalt = () => __awaiter(void 0, void 0, void 0, function* () {
    const salt = yield bcrypt_1.default.genSalt();
    return salt;
});
exports.GenerateSalt = GenerateSalt;
const HashPassword = (password, salt) => __awaiter(void 0, void 0, void 0, function* () {
    const hash = yield bcrypt_1.default.hash(password, salt);
    return hash;
});
exports.HashPassword = HashPassword;
const ValidatePassword = (enteredPassword, savedPassword, salt) => __awaiter(void 0, void 0, void 0, function* () {
    return (yield (0, exports.HashPassword)(enteredPassword, salt)) === savedPassword;
});
exports.ValidatePassword = ValidatePassword;
const generateSignature = (payload) => {
    // Ensure APP_SECRET is defined
    if (!process.env.APP_SECRET) {
        throw new Error('APP_SECRET environment variable is not defined');
    }
    const accessToken = jsonwebtoken_1.default.sign(payload, "kkkkkk", {
        expiresIn: '1d',
    });
    const refreshToken = jsonwebtoken_1.default.sign(payload, "kkkkkk", {
        expiresIn: '7d',
    });
    return {
        accessToken,
        refreshToken,
    };
};
exports.generateSignature = generateSignature;
const validateSignature = (req) => __awaiter(void 0, void 0, void 0, function* () {
    const signature = req.get('Authorization');
    if (signature) {
        const payload = jsonwebtoken_1.default.verify(signature.split(' ')[1], "kkkkkk");
        req.user = payload;
        return true;
    }
    return false;
});
exports.validateSignature = validateSignature;
const validateAdminSignature = (req) => __awaiter(void 0, void 0, void 0, function* () {
    const signature = req.get('Authorization');
    if (signature) {
        const payload = jsonwebtoken_1.default.verify(signature.split(' ')[1], "kkkkkk");
        if (payload.role === 'admin') {
            req.user = payload;
            return true;
        }
    }
    return false;
});
exports.validateAdminSignature = validateAdminSignature;
const validateSuperAdminSignature = (req) => __awaiter(void 0, void 0, void 0, function* () {
    const signature = req.get('Authorization');
    if (signature) {
        const payload = jsonwebtoken_1.default.verify(signature.split(' ')[1], "kkkkkk");
        const role = yield role_1.Role.findById(payload.role);
        if ((role === null || role === void 0 ? void 0 : role.name) == 'superadmin') {
            req.user = payload;
            return true;
        }
    }
    return false;
});
exports.validateSuperAdminSignature = validateSuperAdminSignature;
