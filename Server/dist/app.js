"use strict";
// src/app.ts
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
const express = require('express');
const ConnectDatabase_1 = __importDefault(require("./services/ConnectDatabase"));
const Express_1 = __importDefault(require("./services/Express"));
const startServer = () => __awaiter(void 0, void 0, void 0, function* () {
    const app = express();
    yield (0, ConnectDatabase_1.default)();
    yield (0, Express_1.default)(app);
    app.listen(8080, () => {
        console.log('server started 8000');
    });
});
startServer();
