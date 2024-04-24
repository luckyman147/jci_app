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
exports.Task = exports.TaskSchema = void 0;
const mongoose_1 = __importStar(require("mongoose"));
exports.TaskSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    description: { type: String, default: "" },
    AssignTo: [{ type: mongoose_1.default.Schema.Types.ObjectId,
            ref: 'Member',
            default: []
        }],
    isCompleted: { type: Boolean, default: false },
    StartDate: { type: Date, default: Date.now },
    Deadline: { type: Date, default: () => {
            const currentDate = new Date();
            currentDate.setDate(currentDate.getDate() + 1);
            return currentDate;
        } },
    attachedFile: [{ type: mongoose_1.default.Schema.Types.ObjectId,
            ref: 'File',
            default: [] }],
    CheckList: [{ type: mongoose_1.default.Schema.Types.ObjectId,
            ref: 'CheckList', default: [] },
    ],
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
const Task = mongoose_1.default.model('Task', exports.TaskSchema);
exports.Task = Task;
