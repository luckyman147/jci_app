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
exports.Activity = exports.ActivitySchema = void 0;
const mongoose_1 = __importStar(require("mongoose"));
exports.ActivitySchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    ActivityBeginDate: { type: Date, required: true },
    ActivityEndDate: { type: Date },
    ActivityAdress: { type: String,
        default: "Local Menchia"
    },
    ActivityPoints: { type: Number },
    categorie: { type: String, required: true },
    IsPaid: { type: Boolean, default: false },
    Price: { type: Number, default: 0 },
    Participants: [{
            type: mongoose_1.default.Schema.Types.ObjectId,
            ref: 'Member',
            default: []
        }],
    CoverImages: { type: [{ type: String }], required: true }
}, {
    toJSON: {
        transform(doc, ret) {
            delete ret.ActivityPoints;
            delete ret.__v;
            delete ret.createdAt;
            delete ret.updatedAt;
        }
    },
    timestamps: true
});
const Activity = mongoose_1.default.model('Activity', exports.ActivitySchema);
exports.Activity = Activity;
