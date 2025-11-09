const express = require("express")
const router = express.Router()

const alunoController = require("../controllers/aluno.controller")
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
  alunoController.getAlunoById
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  alunoController.getTodosAlunos
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  alunoController.updateAlunoById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  alunoController.deleteAlunoById
)

module.exports = router
