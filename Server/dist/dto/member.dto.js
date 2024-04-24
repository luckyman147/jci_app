"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MemberLoginInputs = exports.EditMemberProfileInputs = exports.CreateMemberInputs = void 0;
const class_validator_1 = require("class-validator");
class CreateMemberInputs {
}
exports.CreateMemberInputs = CreateMemberInputs;
__decorate([
    (0, class_validator_1.IsEmail)()
], CreateMemberInputs.prototype, "email", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.Length)(6, 20)
], CreateMemberInputs.prototype, "password", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], CreateMemberInputs.prototype, "firstName", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], CreateMemberInputs.prototype, "lastName", void 0);
class EditMemberProfileInputs {
}
exports.EditMemberProfileInputs = EditMemberProfileInputs;
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EditMemberProfileInputs.prototype, "firstName", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EditMemberProfileInputs.prototype, "lastName", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)()
], EditMemberProfileInputs.prototype, "phone", void 0);
class MemberLoginInputs {
}
exports.MemberLoginInputs = MemberLoginInputs;
__decorate([
    (0, class_validator_1.IsEmail)()
], MemberLoginInputs.prototype, "email", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.Length)(6, 12)
], MemberLoginInputs.prototype, "password", void 0);
