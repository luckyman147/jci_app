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
exports.Changepassword = exports.forgetPassword = exports.verifyexpiry = exports.getRole = exports.AccessTokenAccess = exports.RefreshTokenAccess = exports.logout = exports.MemberLogin = exports.MemberSignUp = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const member_dto_1 = require("../dto/member.dto");
const auth_dto_1 = require("../dto/auth.dto");
const Member_1 = require("../models/Member");
const utility_1 = require("../utility");
const role_1 = require("../utility/role");
let refreshTokens = [];
//**  Sign Up*/
const MemberSignUp = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const memberInputs = (0, class_transformer_1.plainToClass)(member_dto_1.CreateMemberInputs, req.body);
    const errors = yield (0, class_validator_1.validate)(memberInputs, { validationError: { target: true } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'validation error', errors: errors[0].constraints });
        console.log(errors);
    }
    const { email, password, firstName, lastName } = memberInputs;
    const existmember = yield Member_1.Member.findOne({ email: email });
    if (existmember !== null) {
        return res.status(409).json({ message: 'A member exist the same ' });
    }
    const role = yield (0, role_1.findrole)('member');
    console.log(role);
    const salt = yield (0, utility_1.GenerateSalt)();
    const UserPassword = yield (0, utility_1.HashPassword)(password, salt);
    const Permissions = yield (0, role_1.getPublicPermissions)();
    const result = yield Member_1.Member.create({
        email: email,
        password: UserPassword,
        salt: salt,
        cotisation: [false, false],
        firstName: firstName,
        is_validated: false,
        adress: '',
        phone: '',
        lastName: lastName,
        role: role,
        Permissions: Permissions
    });
    if (result) {
        if (role) {
            role.Members.push(result.id);
            yield role.save();
        }
        console.log(result);
        return res.status(201).json({ message: "sign up completed " });
    }
    console.log('something');
    return res.status(400).json({ message: 'something went wrong' });
});
exports.MemberSignUp = MemberSignUp;
//!Member login
const MemberLogin = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const loginInputs = (0, class_transformer_1.plainToClass)(member_dto_1.MemberLoginInputs, req.body);
    const errors = yield (0, class_validator_1.validate)(loginInputs, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'validation error' });
    }
    const { email, password } = loginInputs;
    let MemberInfo = yield Member_1.Member.findOne({ email: email });
    if (MemberInfo) {
        const validate = yield (0, utility_1.ValidatePassword)(password, MemberInfo.password, MemberInfo.salt);
        if (validate) {
            const { accessToken } = yield (0, utility_1.generateAccessToken)({
                _id: MemberInfo._id,
                email: MemberInfo.email,
                role: MemberInfo.role._id,
            });
            const { refreshToken } = yield (0, utility_1.generateRefreshToken)({
                _id: MemberInfo._id,
                email: MemberInfo.email,
            });
            console.log("login");
            return res.status(200).json({ refreshToken: refreshToken, accessToken: accessToken, email: MemberInfo.email, role: yield (0, role_1.findroleByid)(MemberInfo.role._id),
                Permissions: yield (0, role_1.getPermissionsKeys)(MemberInfo.Permissions, MemberInfo.role) });
        }
        else {
            return res.status(400).json({ message: 'Invalid credentials' });
        }
    }
    return res.status(404).json({ message: 'Not Found' });
});
exports.MemberLogin = MemberLogin;
//& logout 
const logout = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const signature = (_a = req.get('Authorization')) === null || _a === void 0 ? void 0 : _a.split(' ')[1];
    const member = req.member;
    try {
        const { refreshToken } = req.body;
        if (member && signature) {
            const respnse = yield (0, utility_1.revokeRefreshToken)(member === null || member === void 0 ? void 0 : member.email, member === null || member === void 0 ? void 0 : member._id, refreshToken, signature);
            res.status(200).json(respnse);
        }
        else {
            res.status(400).json({ message: "You are not logged in" });
        }
        // Revoke the refresh token
    }
    catch (error) {
        console.error('Error during logout:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});
exports.logout = logout;
//* refreh token
const RefreshTokenAccess = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    var _b;
    const refreshTokenInput = (_b = req.get('Authorization')) === null || _b === void 0 ? void 0 : _b.split(' ')[1];
    if (refreshTokenInput == null)
        return res.sendStatus(401).json('no token found');
    const accessTokenOrError = yield (0, utility_1.VerifyrefreshToken)(refreshTokenInput);
    console.log(accessTokenOrError);
    if ((accessTokenOrError === null || accessTokenOrError === void 0 ? void 0 : accessTokenOrError.accessToken.toString().length) > 0) {
        return res.status(200).json(accessTokenOrError);
    }
    else {
        return res.status(400).json(accessTokenOrError);
    }
});
exports.RefreshTokenAccess = RefreshTokenAccess;
const AccessTokenAccess = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
});
exports.AccessTokenAccess = AccessTokenAccess;
const getRole = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
});
exports.getRole = getRole;
const verifyexpiry = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
});
exports.verifyexpiry = verifyexpiry;
const forgetPassword = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const NewCred = (0, class_transformer_1.plainToClass)(auth_dto_1.forgetPasswordInputs, req.body);
    const errors = yield (0, class_validator_1.validate)(NewCred, { validationError: { target: false } });
    if (errors.length > 0) {
        console.log(errors);
        return res.status(401).json(errors);
    }
    // send email to the user with reset password link
    // let code=generate_code();
    let status = 200;
    const ischanged = yield (0, exports.Changepassword)(NewCred.email, NewCred.password);
    if (ischanged) {
        console.log('password changed');
        return res.status(status).json({ message: "password changed" });
    }
    else {
        console.log('password not changed');
        return res.status(400).json({ message: "Something missed" });
    }
});
exports.forgetPassword = forgetPassword;
const Changepassword = (email, password) => __awaiter(void 0, void 0, void 0, function* () {
    const member = yield Member_1.Member.findOne({ email: email });
    try {
        if (member) {
            const UserPassword = yield (0, utility_1.HashPassword)(password, member.salt);
            member.password = UserPassword;
            yield member.save();
        }
        return true;
    }
    catch (err) {
        return false;
    }
});
exports.Changepassword = Changepassword;
