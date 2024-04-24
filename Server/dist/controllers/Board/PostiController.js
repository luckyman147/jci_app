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
exports.UpdatePost = exports.RemoveAssignTo = exports.AddAssignTo = exports.DeletePost = exports.AddPost = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const board_dto_1 = require("../../dto/board.dto");
const Post_1 = require("../../models/Board/Post");
const AddPost = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const Inputs = (0, class_transformer_1.plainToClass)(board_dto_1.PostInput, req.body);
        // Validate the inputs
        const errors = yield (0, class_validator_1.validate)(Inputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const post = new Post_1.Post({ year: Inputs.year, role: Inputs.role });
        yield post.save();
        res.status(201).json(post);
    }
    catch (error) {
        res.status(500).json({ message: "Error adding post", error });
    }
});
exports.AddPost = AddPost;
const DeletePost = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    try {
        const post = yield Post_1.Post.findByIdAndDelete(id);
        if (post) {
            res.status(204).json();
        }
        else {
            res.status(404).json({ message: "Post not found" });
        }
    }
    catch (error) {
        res.status(500).json({ message: "Error deleting post", error });
    }
});
exports.DeletePost = DeletePost;
const AddAssignTo = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const { assignTo } = req.body;
    try {
        const post = yield Post_1.Post.findByIdAndUpdate(id, { $push: { assignTo: assignTo } });
        if (post) {
            res.status(200).json();
        }
        else {
            res.status(404).json({ message: "Post not found" });
        }
    }
    catch (e) {
        res.status(500).json({ message: "Error adding assignTo", e });
    }
});
exports.AddAssignTo = AddAssignTo;
const RemoveAssignTo = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const { assignTo } = req.body;
    try {
        const post = yield Post_1.Post.findByIdAndUpdate(id, { $pull: { assignTo: assignTo } });
        if (post) {
            res.status(200).json();
        }
        else {
            res.status(404).json({ message: "Post not found" });
        }
    }
    catch (e) {
        res.status(500).json({ message: "Error removing assignTo", e });
    }
});
exports.RemoveAssignTo = RemoveAssignTo;
const UpdatePost = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const Inputs = (0, class_transformer_1.plainToClass)(board_dto_1.PostInput, req.body);
    // Validate the inputs
    const errors = yield (0, class_validator_1.validate)(Inputs, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }
    let post = yield Post_1.Post.findByIdAndUpdate(id, { role: Inputs.role });
    if (post) {
        res.status(200).json(post);
    }
    else {
        res.status(404).json({ message: "Post not found" });
    }
});
exports.UpdatePost = UpdatePost;
