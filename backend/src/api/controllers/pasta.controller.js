const mongoose = require("mongoose")
const fs = require('fs');

const Pasta = require("../../models/Pasta.model")
const Arquivo = require("../../models/Arquivo.model")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

const {
  PASTA,
  ERRO,
  AUTH
} = require("../../constants/responseMessages.constants")

async function deletarPastaERecursos(pastaId) {
  
  // 1. Encontrar todas as subpastas diretas
  // CORREÇÃO: Usando o campo 'pastaPai' do seu model 'Pasta'
  const subpastas = await Pasta.find({ pastaPai: pastaId });

  // 2. CHAMADA RECURSIVA: Para cada subpasta, chame esta mesma função.
  // Isso garante que vamos "até o fundo" da árvore primeiro.
  for (const sub of subpastas) {
    await deletarPastaERecursos(sub._id);
  }

  // 3. Encontrar todos os arquivos (Materiais) dentro DESTA pasta
  // CORREÇÃO: Usando o model 'Arquivo' e o campo 'pastaOndeSeEncontra'
  const arquivos = await Arquivo.find({ pastaOndeSeEncontra: pastaId });

  // 4. Deletar os ARQUIVOS FÍSICOS do servidor (da pasta /uploads)
  for (const arq of arquivos) {
    try {
      // 'caminho' está correto de acordo com seu model 'Arquivo'
      await fs.promises.unlink(arq.caminho); 
    } catch (err) {
      // Loga o erro, mas continua o processo.
      // (Ex: o arquivo já foi deletado manualmente do disco)
      console.warn(`Não foi possível deletar o arquivo físico: ${arq.caminho}`, err.message);
    }
  }

  // 5. Deletar os DOCUMENTOS de 'Arquivo' do MongoDB
  // CORREÇÃO: Usando 'Arquivo.deleteMany' e 'pastaOndeSeEncontra'
  await Arquivo.deleteMany({ pastaOndeSeEncontra: pastaId });

  // 6. Finalmente, deletar a própria pasta atual (que agora está vazia)
  await Pasta.findByIdAndDelete(pastaId);
}

exports.createPasta = async (req, res) => {
  try
  {
    const { nome, pastaPai } = req.body
    const criadorDaPasta = req.user.id

    const pasta = new Pasta({ nome, pastaPai: pastaPai || null, criadorDaPasta })

    await pasta.save()

    res.status(201).json({
      mensagem: PASTA.CRIADA_COM_SUCESSO,
      pasta: pasta
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      return res.status(409).json({mensagem: PASTA.NOME_EM_USO})
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

exports.getTodasPastas = async (req, res) => {
  try
  {
    const pastas = await Pasta.find({ pastaPai: null }).select("-__v") // Find root folders
    res.status(200).json({
      mensagem: PASTA.TODAS_PASTAS_ENCONTRADAS,
      pastas: pastas
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getPastaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: PASTA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PASTA.ID_FORNECIDO_INVALIDO})

    const pasta = await Pasta.findById(id).select("-__v")

    if (!pasta)
      return res.status(404).json({mensagem: PASTA.NAO_ENCONTRADA})

    res.status(200).json({
      mensagem: PASTA.ENCONTRADA_COM_SUCESSO,
      pasta: pasta
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updatePastaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: PASTA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PASTA.ID_FORNECIDO_INVALIDO})

    const{ nome } = req.body

    const pasta = await Pasta.findById(id)

    if (!pasta)
      return res.status(404).json({mensagem: PASTA.NAO_ENCONTRADA})

    // Check for user permission if needed
    if(pasta.criadorDaPasta.toString() !== req.user.id)
      return res.status(403).json({mensagem: AUTH.NAO_TEM_PERMISSAO})

    if(nome) pasta.nome = nome

    await pasta.save()

    res.status(200).json({
      mensagem: PASTA.ATUALIZADA_COM_SUCESSO,
      pasta: pasta
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      return res.status(409).json({mensagem: PASTA.NOME_EM_USO})
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

exports.deletePastaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: PASTA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PASTA.ID_FORNECIDO_INVALIDO})

    const pasta = await Pasta.findById(id)
    if (!pasta)
      return res.status(404).json({mensagem: PASTA.NAO_ENCONTRADA})
    
    // Check for user permission if needed
    if(pasta.criadorDaPasta.toString() !== req.user.id)
      return res.status(403).json({mensagem: AUTH.NAO_TEM_PERMISSAO})

    await deletarPastaERecursos(id);

    res.status(200).json({
      mensagem: PASTA.DELETADA_COM_SUCESSO,
      pasta: pasta
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getPastasByPaiId = async (req, res) => {
  try
  {
    const {id} = req.params;

    if(!id)
      return res.status(400).json({mensagem: PASTA.ID_NAO_FORNECIDO});

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PASTA.ID_FORNECIDO_INVALIDO});

    const pastaPai = await Pasta.findById(id);
    if (!pastaPai) {
      return res.status(404).json({mensagem: PASTA.NAO_ENCONTRADA});
    }

    const subPastas = await Pasta.find({ pastaPai: id }).select("-__v");

    res.status(200).json({
      mensagem: PASTA.SUBPASTAS_ENCONTRADAS,
      pastas: subPastas
    });
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR});
  }
}
