import express from "express";
import { AddBoardRole, DeleteBoardRole, GetAllBoardRoles, UpdateBoardRole } from "../../controllers/Board/boardRoleController";
import { AddAssignTo, AddPost, DeletePost, RemoveAssignTo, UpdatePost } from "../../controllers/Board/PostiController";




const router =express.Router()


/**
 * @swagger
 * /PositionOfMember/AddPosition:
 *   post:
 *     summary: Add a Position 
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               year:
 *                 type: string
 *               role:
 *                 type:number
 *             required:
 *               - year
 *               - role
 *     responses:
 *       201:
 *         description: Successfully added a position 
 */

router.post('/AddPosition',AddPost)

/**
 * @swagger
 * /PositionOfMember/{id}:
 *   patch:
 *     summary: Update a board Role
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: id of the pos
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               year:
 *                 type: string
 *               role:
 *                 type:string
 *               assignto:
 *                 type:string
 *             required:
 *               - year
 *               - role
 *     responses:
 *       200:
 *         description: Successfully patch a Position of member
 */

router.patch('/:id',UpdatePost)
/**
 * @swagger
 * /PositionOfMember/{id}/{year}:
 *   delete:
 *     summary: Delete a position by ID and year
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the board role
 *       - in: path
 *         name: year
 *         required: true
 *         schema:
 *           type: string
 *         description: Year of the board role
 *     responses:
 *       204:
 *         description: Successfully deleted the board role
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Member's position for selected year is deleted successfully
 */


router.delete("/:id/:year",DeletePost)
/**
 * @swagger
 * /PositionOfMember/{id}/AddMember:
 *   post:
 *     summary: add a position by ID and year
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the position
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               assignTo:
 *                 type: string
 *             required:
 *               - assignTo
 *     responses:
 *       200:
 *         description: Add Assign to 
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Member is added successfully
 */


router.post('/:id/AddMember',AddAssignTo)/**
/**
 * @swagger
 * /PositionOfMember/{id}/RemoveMember:
 *   post:
 *     summary: Remove a member by ID and year
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the position
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               assignTo:
 *                 type: string
 *             required:
 *               - assignTo
 *     responses:
 *       200:
 *         description: Member is removed successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Member is removed successfully
 */

router.post('/:id/RemoveMember',RemoveAssignTo)
export { router as PosRouter };
