const express = require("express")
const router = express.Router()

const pastaController = require("../controllers/pasta.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas públicas

// Rotas protegidas
router.get(
  "/:id",
  authMiddleware,
  pastaController.getPastaById
)

router.get(
  "/",
  authMiddleware,
  pastaController.getTodasPastas
)

router.get(
  "/:id/subpastas",
  authMiddleware,
  pastaController.getPastasByPaiId
);

// Rotas restritas
router.post(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  pastaController.createPasta
)
  
router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  pastaController.updatePastaById
)
  
router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  pastaController.deletePastaById
)

module.exports = router
