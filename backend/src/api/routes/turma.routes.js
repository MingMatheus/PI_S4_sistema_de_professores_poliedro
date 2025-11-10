const express = require("express")
const router = express.Router()

const turmaController = require("../controllers/turma.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas públicas

// Rotas protegidas

// Rotas restritas
router.post(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  turmaController.cadastraTurma
)

router.get(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  turmaController.getTurmaById
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  turmaController.getTodasTurmas
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  turmaController.updateTurmaById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  turmaController.deleteTurmaById
)

module.exports = router
