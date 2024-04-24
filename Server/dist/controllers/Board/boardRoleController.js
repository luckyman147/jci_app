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
exports.UpdateBoardRole = exports.DeleteBoardRole = exports.AddBoardRole = exports.GetAllBoardRoles = void 0;
const BoardRole_1 = require("../../models/Board/BoardRole");
const class_transformer_1 = require("class-transformer");
const board_dto_1 = require("../../dto/board.dto");
const class_validator_1 = require("class-validator");
const GetAllBoardRoles = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const boardRoles = yield BoardRole_1.BoardRole.find();
        res.status(200).json(boardRoles);
    }
    catch (error) {
        res.status(500).json({ message: "Error retrieving board roles", error });
    }
});
exports.GetAllBoardRoles = GetAllBoardRoles;
const AddBoardRole = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const Inputs = (0, class_transformer_1.plainToClass)(board_dto_1.BoardRoleInput, req.body);
        // Validate the inputs
        const errors = yield (0, class_validator_1.validate)(Inputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const boardRole = new BoardRole_1.BoardRole({ name: Inputs.name, priority: Inputs.priority });
        yield boardRole.save();
        res.status(201).json(boardRole);
    }
    catch (error) {
        res.status(500).json({ message: "Error adding board role", error });
    }
});
exports.AddBoardRole = AddBoardRole;
const DeleteBoardRole = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    try {
        const boardRole = yield BoardRole_1.BoardRole.findByIdAndDelete(id);
        if (boardRole) {
            res.status(204).json();
        }
        else {
            res.status(404).json({ message: "Board role not found" });
        }
    }
    catch (error) {
        res.status(500).json({ message: "Error deleting board role", error });
    }
});
exports.DeleteBoardRole = DeleteBoardRole;
const UpdateBoardRole = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const Inputs = (0, class_transformer_1.plainToClass)(board_dto_1.BoardRoleInput, req.body);
    // Validate the inputs
    const errors = yield (0, class_validator_1.validate)(Inputs, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }
    try {
        const boardRole = yield BoardRole_1.BoardRole.findByIdAndUpdate(id, { name: Inputs.name, priority: Inputs.priority }, { new: true });
        if (boardRole) {
            res.status(200).json(boardRole);
        }
        else {
            res.status(404).json({ message: "Board role not found" });
        }
    }
    catch (error) {
        res.status(500).json({ message: "Error updating board role", error });
    }
});
exports.UpdateBoardRole = UpdateBoardRole;
