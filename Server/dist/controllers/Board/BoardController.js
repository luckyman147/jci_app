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
exports.deleteBoard = exports.addBoard = exports.getBoardByYear = void 0;
//Get Board By year
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const board_dto_1 = require("../../dto/board.dto");
const board_1 = require("../../models/Board/board");
const getBoardByYear = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { year } = req.params;
    try {
        const board = yield board_1.Board.aggregate([
            // Match the board by year
            { $match: { year: year } },
            // Populate the grade field
            {
                $lookup: {
                    from: "posts", // Name of the Grade collection
                    localField: "post",
                    foreignField: "_id",
                    as: "posts",
                },
            },
            // Unwind the grades array
            { $unwind: "$posts" },
            // Lookup to populate the BoardRole
            {
                $lookup: {
                    from: "boardroles", // Name of the BoardRole collection
                    localField: "posts.role",
                    foreignField: "_id",
                    as: "role",
                },
            },
            // Unwind the role array
            { $unwind: "$role" },
            // Match grades by year
            { $match: { "posts.year": year } },
            // Sort by BoardRole priority
            { $sort: { "role.priority": 1 } }, // 1 for ascending, -1 for descending
            // Group by board fields
            {
                $group: {
                    _id: "$_id",
                    year: { $first: "$year" },
                    grade: { $push: "$posts" },
                },
            },
        ]);
        if (board.length === 0) {
            return res.status(404).json({ message: "Board not found" });
        }
        res.status(200).json(board[0]); // Return the first (and only) board from the result
    }
    catch (error) {
        res.status(500).json({ message: "Error retrieving board", error });
    }
});
exports.getBoardByYear = getBoardByYear;
const addBoard = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const Inputs = (0, class_transformer_1.plainToClass)(board_dto_1.BoardInput, req.body);
        // Validate the inputs
        const errors = yield (0, class_validator_1.validate)(Inputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const board = new board_1.Board({ year: Inputs.year });
        yield board.save();
        res.status(201).json(board);
    }
    catch (error) {
        res.status(500).json({ message: "Error adding board", error });
    }
});
exports.addBoard = addBoard;
const deleteBoard = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    try {
        const board = yield board_1.Board.findByIdAndDelete(id);
        if (board) {
            res.status(204).json();
        }
        else {
            res.status(404).json({ message: "Board not found" });
        }
    }
    catch (error) {
        res.status(500).json({ message: "Error deleting board", error });
    }
});
exports.deleteBoard = deleteBoard;
