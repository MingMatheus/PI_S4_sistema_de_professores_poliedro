const express = require("express")
const router = express.Router()

const avisoController = require("../controllers/aviso.controller")
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
  avisoController.createAviso
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avisoController.getTodosAvisos
)

router.get(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avisoController.getAvisoById
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avisoController.updateAvisoById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avisoController.deleteAvisoById
)

module.exports = router
