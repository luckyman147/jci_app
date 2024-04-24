"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TaskInput = exports.FilesInput = exports.firstTaskInput = exports.MembersInput = exports.TimelineInput = exports.IsCompletedInput = exports.TeamInputs = void 0;
const class_validator_1 = require("class-validator");
class TeamInputs {
}
exports.TeamInputs = TeamInputs;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TeamInputs.prototype, "name", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TeamInputs.prototype, "description", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TeamInputs.prototype, "event", void 0);
class IsCompletedInput {
}
exports.IsCompletedInput = IsCompletedInput;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], IsCompletedInput.prototype, "IsCompleted", void 0);
class TimelineInput {
}
exports.TimelineInput = TimelineInput;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TimelineInput.prototype, "StartDate", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TimelineInput.prototype, "Deadline", void 0);
class MembersInput {
}
exports.MembersInput = MembersInput;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MembersInput.prototype, "Member", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MembersInput.prototype, "Status", void 0);
class firstTaskInput {
}
exports.firstTaskInput = firstTaskInput;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], firstTaskInput.prototype, "name", void 0);
class FilesInput {
}
exports.FilesInput = FilesInput;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], FilesInput.prototype, "attachedFile", void 0);
class TaskInput {
}
exports.TaskInput = TaskInput;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TaskInput.prototype, "name", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TaskInput.prototype, "Deadline", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TaskInput.prototype, "StartDate", void 0);
