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
exports.updateImageProfile = exports.EditmemberProfile = exports.GetmemberProfile = exports.MemberVerifyEmail = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const FileModel_1 = require("../models/FileModel");
const member_dto_1 = require("../dto/member.dto");
const Member_1 = require("../models/Member");
const role_1 = require("../utility/role");
const path_1 = __importDefault(require("path"));
const objectifcheck_1 = require("../utility/objectifcheck");
//& Verify email
const MemberVerifyEmail = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const { email } = req.body;
    const member = req.member;
    if (member) {
        const profile = yield Member_1.Member.findById(member === null || member === void 0 ? void 0 : member._id);
        // if(profile){
        //     if(profile.otp ===parseInt(otp) && profile.otp_expiry >= new Date()){
        //         profile.verified=true
        //        const updated= await profile.save()
        //         const signature=generateSignature(
        //             {
        //             _id:updated._id,
        //             email:updated.email,
        //             verified:updated.verified
        //         })
        //         return res.status(200).json({message:'email verified',signature:signature,email:updated.email})
        //     }
        // }
        return res.status(400).json({ message: 'something messed up' });
    }
});
exports.MemberVerifyEmail = MemberVerifyEmail;
const GetmemberProfile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    if (member) {
        const profile = yield Member_1.Member.findById(member === null || member === void 0 ? void 0 : member._id);
        if (profile) {
            const [role, teamsInfo, activitiesInfo, trainingsinfo, meetingsInfo, FilesInfo, objectifs] = yield Promise.all([
                (0, role_1.findroleByid)(profile.role),
                (0, role_1.getteamsInfo)(profile.Teams),
                (0, role_1.getActivitiesInfo)(profile.Activities), (0, role_1.getTrainingInfo)(profile.Activities),
                (0, role_1.getMeetingsInfo)(profile.Activities), (0, role_1.getFilesInfoByIds)(profile.Images), (0, objectifcheck_1.CheckObjectif)(profile.id)
            ]);
            const info = { teams: teamsInfo, Activities: [{ "Events": activitiesInfo, "Trainings": trainingsinfo, "Meetings": meetingsInfo }],
                id: profile.id,
                firstName: profile.firstName,
                lastName: profile.lastName,
                Images: FilesInfo,
                phone: profile.phone,
                email: profile.email,
                cotisation: profile.cotisation,
                role: role,
                points: profile.Points,
                is_validated: profile.is_validated,
                objectifs: objectifs
            };
            console.log(info);
            return res.status(200).json(info);
        }
        return res.status(404).json({ message: 'member not found' });
    }
});
exports.GetmemberProfile = GetmemberProfile;
const EditmemberProfile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    const profileinputs = (0, class_transformer_1.plainToClass)(member_dto_1.EditMemberProfileInputs, req.body);
    const errors = yield (0, class_validator_1.validate)(profileinputs, { validationError: { target: false } });
    if (errors.length > 0) {
        console.log(errors);
        return res.status(400).json(errors);
    }
    const { firstName, lastName, phone } = profileinputs;
    if (member) {
        const profile = yield Member_1.Member.findById(member === null || member === void 0 ? void 0 : member._id);
        if (profile) {
            profile.firstName = firstName;
            profile.lastName = lastName;
            profile.phone = phone;
            const updated = yield profile.save();
            if (updated) {
                return res.status(200).json({ message: 'profile updated' });
            }
            return res.status(400).json({ message: 'error with profile' });
        }
        return res.status(404).json({ message: 'member not found' });
    }
});
exports.EditmemberProfile = EditmemberProfile;
const updateImageProfile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.params.id;
    try {
        const user = yield Member_1.Member.findById(member);
        if (!user) {
            console.log('no user');
            return res.status(404).send("No such user");
        }
        const image = req.file;
        const fileExtension = path_1.default.extname(image.originalname);
        const founded = yield FileModel_1.File
            .findOne({ path: image.originalname });
        if (!founded) {
            // Convert the file to a base64 string
            const base64File = image.buffer.toString('base64');
            const file = new FileModel_1.File({
                path: image.originalname,
                url: base64File,
                extension: fileExtension,
            });
            // Convert the image to base64
            yield file.save();
            // Add the image to the team
            user.Images = [file._id];
            // Save the team
            const saveduser = yield user.save();
            res.status(200).json(saveduser);
        }
        else {
            user.Images = [founded._id];
            const saveduser = yield user.save();
            res.status(200).json(saveduser);
        }
    }
    catch (error) {
        console.log(error);
        res.status(500).json({ error: "errrr" });
    }
});
exports.updateImageProfile = updateImageProfile;
