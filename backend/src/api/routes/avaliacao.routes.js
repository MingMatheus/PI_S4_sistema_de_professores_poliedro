const express = require("express")
const router = express.Router()

const avaliacaoController = require("../controllers/avaliacao.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas restritas ao professor
router.post(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avaliacaoController.createAvaliacao
)

router.get(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avaliacaoController.getAvaliacaoById
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avaliacaoController.getTodasAvaliacoes
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avaliacaoController.updateAvaliacaoById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avaliacaoController.deleteAvaliacaoById
)

module.exports = router
