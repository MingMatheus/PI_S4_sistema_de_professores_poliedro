const express = require("express")
const router = express.Router()

const serieController = require("../controllers/serie.controller")
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
  serieController.cadastraSerie
)

router.get(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  serieController.getSerieById
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  serieController.getTodasSeries
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  serieController.updateSerieById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  serieController.deleteSerieById
)

module.exports = router
