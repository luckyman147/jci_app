"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TrainingInputs = exports.MeetingInputs = exports.EventInputs = void 0;
const class_validator_1 = require("class-validator");
class EventInputs {
}
exports.EventInputs = EventInputs;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "name", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "description", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "ActivityBeginDate", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "ActivityEndDate", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "ActivityAdress", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "categorie", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "registrationDeadline", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EventInputs.prototype, "LeaderName", void 0);
class MeetingInputs {
}
exports.MeetingInputs = MeetingInputs;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MeetingInputs.prototype, "name", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MeetingInputs.prototype, "description", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MeetingInputs.prototype, "agenda", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MeetingInputs.prototype, "ActivityBeginDate", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MeetingInputs.prototype, "categorie", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], MeetingInputs.prototype, "Director", void 0);
class TrainingInputs {
}
exports.TrainingInputs = TrainingInputs;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TrainingInputs.prototype, "name", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TrainingInputs.prototype, "description", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TrainingInputs.prototype, "IsPaid", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TrainingInputs.prototype, "ActivityBeginDate", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TrainingInputs.prototype, "ActivityEndDate", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TrainingInputs.prototype, "categorie", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], TrainingInputs.prototype, "ProfesseurName", void 0);
