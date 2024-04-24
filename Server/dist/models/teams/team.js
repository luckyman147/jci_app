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
Object.defineProperty(exports, "__esModule", { value: true });
exports.team = exports.TeamSchema = void 0;
const mongoose_1 = __importStar(require("mongoose"));
exports.TeamSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    //public-> true if the team is public and false if it is private
    status: { type: Boolean, default: true },
    TeamLeader: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: 'Member',
    },
    Event: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: 'Event',
    },
    Members: [{
            type: mongoose_1.default.Schema.Types.ObjectId,
            ref: 'Member',
            default: []
        }],
    tasks: [{
            type: mongoose_1.default.Schema.Types.ObjectId,
            ref: 'Task',
            default: []
        }],
    CoverImage: { type: String }
}, {
    toJSON: {
        transform(doc, ret) {
            delete ret.__v;
            delete ret.createdAt;
            delete ret.updatedAt;
        }
    },
    timestamps: true
});
const team = mongoose_1.default.model('Team', exports.TeamSchema);
exports.team = team;
