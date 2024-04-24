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
exports.UpdateTeamMembers = exports.addMember = exports.deleteTeam = exports.updateTeam = exports.updateImage = exports.uploadTeamImage = exports.getTeamByName = exports.getTeamById = exports.GetTeams = exports.AddTeam = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const teams_dto_1 = require("../../dto/teams.dto");
const eventModel_1 = require("../../models/activities/eventModel");
const team_1 = require("../../models/teams/team");
const role_1 = require("../../utility/role");
const Member_1 = require("../../models/Member");
const AddTeam = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const user = req.member;
    console.log("ee" + user);
    try {
        console.log(req.body);
        const teamInputs = (0, class_transformer_1.plainToClass)(teams_dto_1.TeamInputs, req.body);
        const errors = yield (0, class_validator_1.validate)(teamInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            console.log(errors);
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        // Create an Event document
        const newTeam = new team_1.team({
            name: teamInputs.name,
            description: teamInputs.description,
            TeamLeader: user._id,
            status: teamInputs.status,
            Event: teamInputs.event,
            Members: Array.isArray(teamInputs.Members) ? [...teamInputs.Members, user._id] : [user._id], tasks: [], CoverImage: ""
        });
        // Add the event to the database
        const savedTeam = yield newTeam.save();
        const event = yield eventModel_1.Event.findById(teamInputs.event);
        if (event) {
            event.teams.push(newTeam._id);
        }
        const leader = yield Member_1.Member.findById(user._id);
        if (leader) {
            leader.Teams.push(newTeam.id);
        }
        yield (leader === null || leader === void 0 ? void 0 : leader.save());
        yield (event === null || event === void 0 ? void 0 : event.save());
        const show = yield showTeamDetails(savedTeam);
        res.json(show);
    }
    catch (error) {
        console.log('Error adding event:', error);
        next(error);
    }
});
exports.AddTeam = AddTeam;
const GetTeams = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const start = parseInt(req.query.start);
    const limit = parseInt(req.query.limit);
    const memberid = req.member._id;
    const IsPrivate = req.query.isPrivate;
    let bollean = false;
    if (IsPrivate == "true") {
        bollean = true;
    }
    const startIndex = start;
    const endIndex = start + limit;
    const results = {};
    if (endIndex < (yield team_1.team.countDocuments().exec())) {
        results.next = {
            start: endIndex,
            limit: limit
        };
    }
    if (startIndex > 0) {
        results.previous = {
            start: Math.max(start - limit, 0), // Ensure start is not negative
            limit: limit
        };
    }
    if (IsPrivate == "false") {
        const teams = yield team_1.team.find({ status: true }).sort({ createdAt: 'desc' }).limit(limit).skip(startIndex).exec();
        if (teams.length > 0) {
            const teamsWithEvent = yield Promise.all(teams.filter(team => team.status == true) // Filtering teams with status true
                .map((team) => __awaiter(void 0, void 0, void 0, function* () {
                return ({
                    id: team._id,
                    event: yield (0, role_1.getEventNameById)(team.Event),
                    description: team.description,
                    TeamLeader: yield (0, role_1.getMembersInfo)([team.TeamLeader]),
                    name: team.name,
                    status: team.status,
                    CoverImage: team.CoverImage,
                    tasks: yield (0, role_1.getTasksInfo)(team.tasks),
                    Members: yield (0, role_1.getMembersInfo)(team.Members),
                });
            })));
            results.results = teamsWithEvent;
            res.status(200).json(results);
        }
        else {
            res.status(404).json({ message: "No teams found" });
        }
    }
    else {
        const teams = yield team_1.team.find({ status: false, Members: memberid }).sort({ createdAt: 'desc' }).limit(limit).skip(startIndex).exec();
        if (teams.length > 0) {
            console.log(memberid);
            const teamsWithEvent = yield Promise.all(teams.map((team) => __awaiter(void 0, void 0, void 0, function* () {
                return ({
                    id: team._id,
                    event: yield (0, role_1.getEventNameById)(team.Event),
                    description: team.description,
                    TeamLeader: yield (0, role_1.getMembersInfo)([team.TeamLeader]),
                    name: team.name,
                    status: team.status,
                    CoverImage: team.CoverImage,
                    tasks: yield (0, role_1.getTasksInfo)(team.tasks),
                    Members: yield (0, role_1.getMembersInfo)(team.Members),
                });
            })));
            results.results = teamsWithEvent;
            res.status(200).json(results);
        }
        else {
            res.status(404).json({ message: "No teams found" });
        }
    }
    ;
});
exports.GetTeams = GetTeams;
const getTeamById = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const id = req.params.id;
        const Team = yield team_1.team.findById(id);
        if (Team) {
            // Convert the base64 string to a Buffer
            const show = yield showTeamDetails(Team);
            res.json(show);
        }
        else {
            res.status(404).json({ message: "No team found with this id" });
        }
    }
    catch (error) {
        console.error('Error retrieving team by id:', error);
        next(error);
    }
});
exports.getTeamById = getTeamById;
const getTeamByName = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const name = req.query.name;
    const memberid = req.member._id;
    try {
        const teams = yield team_1.team.find({
            $or: [
                { status: true },
                {
                    status: false,
                    Members: memberid
                }
            ],
            name: { $regex: name, $options: 'i' } // Regex pattern on the name field
        }).sort({ createdAt: 'desc' }).limit(5);
        if (teams.length > 0) {
            const StatusTeam = teams.filter((team) => team.status == true);
            const show = yield Promise.all(StatusTeam.map(showTeamDetails));
            res.status(200).json(show);
        }
        else {
            res.status(404).json({ message: "No teams found with this name" });
        }
    }
    catch (error) {
        console.error("Error retrieving team by name:", error);
    }
});
exports.getTeamByName = getTeamByName;
const uploadTeamImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const teamId = req.params.id;
        const Team = yield team_1.team.findById(teamId);
        if (!Team) {
            return res.status(404).send("No such team");
        }
        const image = req.file;
        if (!image) {
            return res.status(400).send("Invalid or missing image file");
        }
        // Convert the image to base64
        const base64Image = image.buffer.toString('base64');
        // Add the image to the team
        Team.CoverImage = base64Image;
        // Save the team
        const savedTeam = yield Team.save();
        const show = yield showTeamDetails(savedTeam);
        res.status(200).json(show);
    }
    catch (error) {
        res.status(500).json({ error: error });
    }
});
exports.uploadTeamImage = uploadTeamImage;
const updateImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const teamId = req.params.id;
        const Team = yield team_1.team.findById(teamId);
        if (!Team) {
            return res.status(404).send("No such team");
        }
        const image = req.file;
        if (!image) {
            return res.status(400).send("Invalid or missing image file");
        }
        // Convert the image to base64
        const base64Image = image.buffer.toString('base64');
        // Add the image to the team
        Team.CoverImage = base64Image;
        // Save the team
        const savedTeam = yield Team.save();
        res.status(200).json(savedTeam);
    }
    catch (error) {
        res.status(500).json({ error: "errrr" });
    }
});
exports.updateImage = updateImage;
const updateTeam = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const TeamId = req.params.id;
        // Find the existing Team by ID
        const existingTeam = yield team_1.team.findById(TeamId);
        if (!existingTeam) {
            return res.status(404).json({ message: 'Team not found' });
        }
        // Extract data from the request body
        const teamInputs = (0, class_transformer_1.plainToClass)(teams_dto_1.TeamInputs, req.body);
        const errors = yield (0, class_validator_1.validate)(teamInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        // Update the existing Team properties
        existingTeam.name = teamInputs.name;
        existingTeam.description = teamInputs.description;
        existingTeam.Event = teamInputs.event;
        existingTeam.Members = teamInputs.Members;
        existingTeam.tasks = teamInputs.tasks;
        existingTeam.status = teamInputs.status;
        const updatedTeam = yield existingTeam.save();
        res.json(updatedTeam);
    }
    catch (error) {
        console.error('Error updating Team:', error);
        next(error);
    }
});
exports.updateTeam = updateTeam;
const deleteTeam = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const TeamId = req.params.id;
        // Check if the Team exists
        const Team = yield team_1.team.findById(TeamId);
        if (!Team) {
            return res.status(404).json({ error: 'Team not found' });
        }
        // Delete the Team
        yield Team.deleteOne();
        res.status(204).json({ message: "deleted successully" }); // 204 No Content indicates a successful deletion
    }
    catch (error) {
        console.error('Error deleting event:', error);
        next(error);
    }
});
exports.deleteTeam = deleteTeam;
//TODO add member
const addMember = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const teamId = req.params.id;
        const memberId = req.params.memberId;
        // Check if the team exists
        const Team = yield team_1.team.findById(teamId);
        if (!Team) {
            return res.status(404).json({ error: 'Team not found' });
        }
        const member = yield Member_1.Member.findById(memberId);
        if (!member) {
            return res.status(404).json({ error: 'Member not found' });
        }
        // Add the member to the team's members array
        Team.Members.push(member._id);
        member.Teams.push(Team.id);
        // Save the updated team
        const updatedTeam = yield Team.save();
        res.status(201).json({ member: member, team: updatedTeam });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.addMember = addMember;
const showTeamDetails = (team) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const result = {
            id: team._id,
            event: yield (0, role_1.getEventNameById)(team.Event),
            description: team.description,
            TeamLeader: yield (0, role_1.getMembersInfo)([team.TeamLeader]),
            name: team.name,
            status: team.status,
            CoverImage: team.CoverImage,
            tasks: yield (0, role_1.getTasksInfo)(team.tasks),
            Members: yield (0, role_1.getMembersInfo)(team.Members),
        };
        return result;
    }
    catch (error) {
        console.error("Error in showTeamDetails:", error);
        throw error;
    }
});
const UpdateTeamMembers = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const teamId = req.params.teamid;
        const user = (_a = req.member) === null || _a === void 0 ? void 0 : _a._id;
        const Team = yield team_1.team.findById(teamId);
        if (!Team) {
            return res.status(404).json({ error: 'team not found' });
        }
        const membersInput = (0, class_transformer_1.plainToClass)(teams_dto_1.MembersInput, req.body);
        const errors = yield (0, class_validator_1.validate)(membersInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        console.log(membersInput.Status);
        //invite members
        if (membersInput.Status == "add") {
            console.log(membersInput.Member);
            console.log(membersInput.Status);
            yield Team.Members.push(membersInput.Member);
            yield Team.save();
            const member = yield Member_1.Member.findById(membersInput.Member);
            if (member) {
                member.Teams.push(Team._id);
                yield (member === null || member === void 0 ? void 0 : member.save());
            }
            res.status(200).json({ message: "Completed", Team });
        }
        //kick Member
        else if (membersInput.Status == "kick") {
            console.log(membersInput.Member);
            Team.Members = Team.Members.filter((member) => member._id.toString() !== membersInput.Member.toString());
            yield Team.save();
            const member = yield Member_1.Member.findById(membersInput.Member);
            if (member) {
                member.Teams = member.Teams.filter((mem) => mem.toString() !== Team._id.toString());
                yield (member === null || member === void 0 ? void 0 : member.save());
            }
            res.status(200).json({ message: "Completed", Team });
        }
        else {
            //exit 
            Team.Members = Team.Members.filter((member) => member._id.toString() !== user);
            const member = yield Member_1.Member.findById(user);
            if (member) {
                member.Teams = member.Teams.filter((team) => team.toString() != Team._id.toString());
                yield (member === null || member === void 0 ? void 0 : member.save());
            }
            yield Team.save();
            res.status(200).json({ message: "Completed", Team });
        }
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.UpdateTeamMembers = UpdateTeamMembers;
