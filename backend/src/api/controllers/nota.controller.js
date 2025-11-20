const mongoose = require("mongoose")
const Nota = require("../../models/Nota.model")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

const {
  NOTA,
  AVALIACAO,
  ERRO,
} = require("../../constants/responseMessages.constants")

exports.createNota = async (req, res) => {
  try {
    const nota = new Nota(req.body);
    const novaNota = await nota.save();

    res.status(201).json({
      mensagem: NOTA.CRIADA_COM_SUCESSO,
      nota: novaNota
    });
  } catch (error) {
    if (error.code == MONGO_DUPLICATE_KEY) {
      return res.status(409).json({ mensagem: NOTA.JA_EXISTE });
    }

    if (error.name == MONGOOSE_VALIDATION_ERROR) {
      const errorMessages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      });
    }

    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR });
  }
}

exports.getTodasNotas = async (req, res) => {
  try
  {
    // Note: In a real application, you'd likely want to filter these,
    // e.g., by alunoId or avaliacaoId.
    const notas = await Nota.find().select("-__v")
    res.status(200).json({
      mensagem: NOTA.TODAS_NOTAS_ENCONTRADAS,
      notas: notas
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getNotaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: NOTA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: NOTA.ID_FORNECIDO_INVALIDO})

    const nota = await Nota.findById(id).select("-__v")

    if (!nota)
      return res.status(404).json({mensagem: NOTA.NAO_ENCONTRADA})

    res.status(200).json({
      mensagem: NOTA.ENCONTRADA_COM_SUCESSO,
      nota: nota
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateNotaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: NOTA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: NOTA.ID_FORNECIDO_INVALIDO})

    const { notaObtida } = req.body

    // 1. Find
    const nota = await Nota.findById(id).select("-__v")

    if (!nota)
      return res.status(404).json({mensagem: NOTA.NAO_ENCONTRADA})

    // 2. Modify
    if(notaObtida) nota.notaObtida = notaObtida

    // 3. Save
    await nota.save()

    res.status(200).json({
      mensagem: NOTA.ATUALIZADA_COM_SUCESSO,
      nota: nota
    })
  }
  catch(error)
  {
    if (error.code == MONGO_DUPLICATE_KEY) {
      return res.status(409).json({ mensagem: NOTA.JA_EXISTE });
    }
    
    if(error.name == MONGOOSE_VALIDATION_ERROR)
    {
      const errorMessages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      })
    }

    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.deleteNotaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: NOTA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: NOTA.ID_FORNECIDO_INVALIDO})
      
    const nota = await Nota.findByIdAndDelete(id).select("-__v");

    if (!nota)
      return res.status(404).json({mensagem: NOTA.NAO_ENCONTRADA});

    res.status(200).json({
      mensagem: NOTA.DELETADA_COM_SUCESSO,
      nota: nota
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getNotasByAvaliacao = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: AVALIACAO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: AVALIACAO.ID_FORNECIDO_INVALIDO})

    const notas = await Nota.find({ avaliacao: id }).select("-__v");

    res.status(200).json({
      mensagem: NOTA.NOTAS_DA_AVALIACAO_ENCONTRADAS,
      notas: notas
    });
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR});
  }
}
