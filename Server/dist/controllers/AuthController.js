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
Object.defineProperty(exports, "__esModule", { value: true });
exports.getRole = exports.AccessTokenAccess = exports.RefreshTokenAccess = exports.logout = exports.MemberLogin = exports.MemberSignUp = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const member_dto_1 = require("../dto/member.dto");
const Member_1 = require("../models/Member");
const PasswordUtility_1 = require("../utility/PasswordUtility");
const role_1 = require("../utility/role");
//**  Sign Up*/
const MemberSignUp = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const memberInputs = (0, class_transformer_1.plainToClass)(member_dto_1.CreateMemberInputs, req.body);
    console.log(memberInputs);
    const errors = yield (0, class_validator_1.validate)(memberInputs, { validationError: { target: true } });
    if (errors.length > 0) {
        return res.status(400).json(errors);
    }
    const { email, password, firstName, lastName } = memberInputs;
    const existmember = yield Member_1.Member.findOne({ email: email });
    if (existmember !== null) {
        return res.status(409).json({ message: 'A member exist the same ' });
    }
    const role = yield (0, role_1.findrole)('member');
    const salt = yield (0, PasswordUtility_1.GenerateSalt)();
    const UserPassword = yield (0, PasswordUtility_1.HashPassword)(password, salt);
    const result = yield Member_1.Member.create({
        email: email,
        password: UserPassword,
        salt: salt,
        cotisation: [false],
        firstName: firstName,
        is_validated: false,
        adress: '',
        phone: '',
        lastName: lastName,
        role: role
    });
    if (result) {
        role === null || role === void 0 ? void 0 : role.Members.push(result.id);
        return res.status(201).json({ message: "sign up completed ", _id: result.id, is_validated: result.is_validated, email: result.email });
    }
    return res.status(400).json({ message: 'something went wrong' });
});
exports.MemberSignUp = MemberSignUp;
//!Member login
const MemberLogin = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const loginInputs = (0, class_transformer_1.plainToClass)(member_dto_1.MemberLoginInputs, req.body);
    const errors = yield (0, class_validator_1.validate)(loginInputs, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json(errors);
    }
    const { email, password } = loginInputs;
    let MemberInfo = yield Member_1.Member.findOne({ email: email });
    if (MemberInfo) {
        const validate = yield (0, PasswordUtility_1.ValidatePassword)(password, MemberInfo.password, MemberInfo.salt);
        if (validate) {
            const { accessToken, refreshToken } = (0, PasswordUtility_1.generateSignature)({
                _id: MemberInfo._id,
                email: MemberInfo.email,
                role: MemberInfo.role._id
            });
            return res.status(200).json({ message: 'login success', refreshToken: refreshToken, accessToken: accessToken, email: MemberInfo.email });
        }
        else {
            return res.status(400).json({ message: 'Invalid credentials' });
        }
    }
    return res.status(404).json({ message: 'Not Found' });
});
exports.MemberLogin = MemberLogin;
const logout = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
});
exports.logout = logout;
const RefreshTokenAccess = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
});
exports.RefreshTokenAccess = RefreshTokenAccess;
const AccessTokenAccess = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
});
exports.AccessTokenAccess = AccessTokenAccess;
const getRole = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
});
exports.getRole = getRole;
