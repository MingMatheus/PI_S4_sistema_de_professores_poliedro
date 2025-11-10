const express = require("express")
const router = express.Router()

const professorController = require("../controllers/professor.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas públicas

// Rotas protegidas

// Rotas restritas
router.get(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  professorController.getProfessorById
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  professorController.getTodosProfessores
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  professorController.updateProfessorById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  professorController.deleteProfessorById
)

module.exports = router
