<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Peptide Manager</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { darkMode: 'media' }
    </script>
    <!-- FontAwesome para ícones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Alpine.js -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-100 dark:bg-gray-900 text-gray-800 dark:text-gray-100 font-sans pb-24 transition-colors duration-300" x-data="peptideApp()" x-init="initApp()">

    <!-- HEADER -->
    <header class="bg-indigo-600 dark:bg-indigo-800 text-white p-4 shadow-md sticky top-0 z-10 flex justify-between items-center">
        <h1 class="text-lg font-bold flex items-center gap-2">
            <i class="fa-solid fa-syringe"></i> Peptide Manager
        </h1>
        <div class="flex gap-2">
            <button @click="exportData()" class="text-xs bg-indigo-700 hover:bg-indigo-600 text-white px-2 py-1.5 rounded-lg shadow-sm font-medium transition" title="Exportar Backup">
                <i class="fa-solid fa-cloud-arrow-down"></i> Exportar
            </button>
        </div>
    </header>

    <main class="p-4 max-w-md mx-auto">

        <!-- ABA 1: CALCULADORA & ESTOQUE -->
        <section x-show="activeTab === 'calc'" class="space-y-4">
            <div class="bg-white dark:bg-gray-800 p-5 rounded-2xl shadow-sm space-y-4 border border-transparent dark:border-gray-700">
                <div class="flex justify-between items-center border-b dark:border-gray-700 pb-2">
                    <h2 class="text-md font-semibold text-indigo-600 dark:text-indigo-400">Calculadora & Estoque</h2>
                    <div class="text-xs font-bold bg-green-100 dark:bg-green-900 text-green-700 dark:text-green-300 px-2 py-1 rounded-md">
                        Estoque: <span x-text="currentStockMg + ' mg'"></span>
                    </div>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-gray-600 dark:text-gray-400 mb-1">Frasco Total Inicial (mg)</label>
                    <div class="flex gap-2">
                        <input type="number" x-model.number="vialMg" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white focus:ring-2 focus:ring-indigo-500">
                        <button @click="resetStock()" class="bg-gray-200 dark:bg-gray-600 text-gray-700 dark:text-gray-200 px-3 rounded-xl hover:bg-gray-300 transition" title="Reiniciar Estoque">
                            <i class="fa-solid fa-rotate-left"></i>
                        </button>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-600 dark:text-gray-400 mb-1">Água Bacteriostática (mL)</label>
                    <input type="number" x-model.number="waterMl" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white focus:ring-2 focus:ring-indigo-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-600 dark:text-gray-400 mb-1">Dose Desejada (mcg)</label>
                    <input type="number" x-model.number="desiredMcg" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white focus:ring-2 focus:ring-indigo-500">
                </div>
            </div>

            <!-- RESULTADOS -->
            <div class="bg-indigo-50 dark:bg-gray-800 border border-indigo-100 dark:border-gray-700 p-5 rounded-2xl space-y-4">
                <div class="flex justify-between items-center border-b border-indigo-200 dark:border-gray-600 pb-2">
                    <span class="font-bold text-indigo-900 dark:text-indigo-300">Na Seringa (Insulina):</span>
                    <span class="text-2xl font-extrabold text-indigo-600 dark:text-indigo-400" x-text="insulinUnits.toFixed(1) + ' unidades'"></span>
                </div>
                <button @click="deductFromStock()" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 rounded-xl transition flex justify-center items-center gap-2 shadow-sm">
                    <i class="fa-solid fa-vial"></i> Subtrair dose do frasco
                </button>
            </div>
        </section>

        <!-- ABA 2: PROTOCOLOS -->
        <section x-show="activeTab === 'protocols'" class="space-y-4">
            <div class="flex justify-between items-center">
                <h2 class="text-md font-semibold text-gray-700 dark:text-gray-200">Meus Protocolos</h2>
                <button @click="openProtocolModal()" class="bg-indigo-600 text-white px-3 py-1.5 rounded-xl text-sm font-medium shadow hover:bg-indigo-700">
                    <i class="fa-solid fa-plus mr-1"></i> Novo
                </button>
            </div>

            <template x-for="(proto, index) in protocols" :key="index">
                <div class="bg-white dark:bg-gray-800 p-4 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 flex flex-col gap-3">
                    <div class="flex justify-between items-start">
                        <div>
                            <h3 class="font-bold text-gray-800 dark:text-gray-100 text-lg" x-text="proto.name"></h3>
                            <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">Dose: <span class="font-bold text-indigo-600 dark:text-indigo-400" x-text="proto.dose"></span></p>
                        </div>
                        <div class="flex gap-1">
                            <button @click="openProtocolModal(index)" class="text-blue-500 dark:text-blue-400 hover:text-blue-700 p-2 bg-blue-50 dark:bg-gray-700 rounded-lg transition"><i class="fa-solid fa-pen-to-square"></i></button>
                            <button @click="protocols.splice(index, 1)" class="text-red-500 dark:text-red-400 hover:text-red-700 p-2 bg-red-50 dark:bg-gray-700 rounded-lg transition"><i class="fa-solid fa-trash-can"></i></button>
                        </div>
                    </div>
                    <div class="bg-indigo-50 dark:bg-gray-700 text-indigo-700 dark:text-indigo-300 text-xs font-semibold px-3 py-2 rounded-xl flex items-center gap-2 border border-indigo-100 dark:border-gray-600">
                        <i class="fa-solid fa-stopwatch animate-pulse"></i>
                        <span x-text="timeUntilNext(proto)"></span>
                    </div>
                </div>
            </template>
        </section>

        <!-- ABA 3: LOCAIS DE APLICAÇÃO -->
        <section x-show="activeTab === 'sites'" class="space-y-4">
            <div class="flex justify-between items-center">
                <h2 class="text-md font-semibold text-gray-700 dark:text-gray-200">Histórico de Locais</h2>
                <button @click="openSiteModal()" class="bg-indigo-600 text-white px-3 py-1.5 rounded-xl text-sm font-medium shadow hover:bg-indigo-700">
                    <i class="fa-solid fa-plus mr-1"></i> Registrar
                </button>
            </div>

            <template x-for="(log, index) in siteLogs" :key="index">
                <div class="bg-white dark:bg-gray-800 p-4 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700">
                    <div class="flex justify-between items-start">
                        <div>
                            <h3 class="font-bold text-gray-800 dark:text-gray-100" x-text="log.compound"></h3>
                            <p class="text-sm text-indigo-600 dark:text-indigo-400 font-medium mt-1"><i class="fa-solid fa-location-dot mr-1"></i> <span x-text="log.siteFormatted"></span></p>
                            <span class="inline-block mt-2 text-xs text-gray-500 bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded-md" x-text="formatDateBR(log.date)"></span>
                        </div>
                        <div class="flex gap-1">
                            <button @click="openSiteModal(index)" class="text-blue-500 dark:text-blue-400 p-2 bg-blue-50 dark:bg-gray-700 rounded-lg"><i class="fa-solid fa-pen-to-square"></i></button>
                            <button @click="siteLogs.splice(index, 1)" class="text-red-500 dark:text-red-400 p-2 bg-red-50 dark:bg-gray-700 rounded-lg"><i class="fa-solid fa-trash-can"></i></button>
                        </div>
                    </div>
                </div>
            </template>
        </section>

        <!-- ABA 4: PROGRESSO -->
        <section x-show="activeTab === 'progress'" class="space-y-4">
            <div class="flex justify-between items-center">
                <h2 class="text-md font-semibold text-gray-700 dark:text-gray-200">Diário de Progresso</h2>
                <button @click="openProgressModal()" class="bg-indigo-600 text-white px-3 py-1.5 rounded-xl text-sm font-medium shadow hover:bg-indigo-700">
                    <i class="fa-solid fa-plus mr-1"></i> Adicionar
                </button>
            </div>

            <template x-for="(log, index) in progressLogs" :key="index">
                <div class="bg-white dark:bg-gray-800 p-4 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700">
                    <div class="flex justify-between items-start mb-2 border-b dark:border-gray-700 pb-2">
                        <span class="text-sm text-gray-500 dark:text-gray-400 font-medium"><i class="fa-regular fa-calendar"></i> <span x-text="formatDateBR(log.date)"></span></span>
                        <button @click="progressLogs.splice(index, 1)" class="text-red-500 dark:text-red-400 p-1"><i class="fa-solid fa-trash-can"></i></button>
                    </div>
                    <div class="flex gap-4 mb-2">
                        <div x-show="log.weight" class="bg-blue-50 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 px-3 py-1 rounded-lg text-sm font-bold">
                            <i class="fa-solid fa-weight-scale mr-1"></i> <span x-text="log.weight + ' kg'"></span>
                        </div>
                    </div>
                    <p x-show="log.sideEffects" class="text-sm text-red-600 dark:text-red-400 mt-2"><strong>Sintomas:</strong> <span x-text="log.sideEffects"></span></p>
                    <p x-show="log.notes" class="text-sm text-gray-600 dark:text-gray-300 mt-1 italic" x-text="'&quot;' + log.notes + '&quot;'"></p>
                </div>
            </template>
        </section>

    </main>

    <!-- MENU DE NAVEGAÇÃO INFERIOR -->
    <nav class="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 py-2 px-6 flex justify-around shadow-lg z-20">
        <button @click="activeTab = 'calc'" :class="activeTab === 'calc' ? 'text-indigo-600 dark:text-indigo-400' : 'text-gray-400 dark:text-gray-500'" class="flex flex-col items-center gap-1 transition">
            <i class="fa-solid fa-calculator text-lg"></i><span class="text-xs font-medium">Calcular</span>
        </button>
        <button @click="activeTab = 'protocols'" :class="activeTab === 'protocols' ? 'text-indigo-600 dark:text-indigo-400' : 'text-gray-400 dark:text-gray-500'" class="flex flex-col items-center gap-1 transition">
            <i class="fa-solid fa-pills text-lg"></i><span class="text-xs font-medium">Protocolos</span>
        </button>
        <button @click="activeTab = 'sites'" :class="activeTab === 'sites' ? 'text-indigo-600 dark:text-indigo-400' : 'text-gray-400 dark:text-gray-500'" class="flex flex-col items-center gap-1 transition">
            <i class="fa-solid fa-map-pin text-lg"></i><span class="text-xs font-medium">Locais</span>
        </button>
        <button @click="activeTab = 'progress'" :class="activeTab === 'progress' ? 'text-indigo-600 dark:text-indigo-400' : 'text-gray-400 dark:text-gray-500'" class="flex flex-col items-center gap-1 transition">
            <i class="fa-solid fa-chart-line text-lg"></i><span class="text-xs font-medium">Progresso</span>
        </button>
    </nav>

    <!-- MODAL DE PROTOCOLO -->
    <div x-show="showProtocolModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
        <div class="bg-white dark:bg-gray-800 w-full max-w-sm p-6 rounded-3xl space-y-4 shadow-xl max-h-[90vh] overflow-y-auto">
            <h3 class="text-lg font-bold text-gray-800 dark:text-white" x-text="editingProtoIndex !== null ? 'Editar Protocolo' : 'Adicionar Protocolo'"></h3>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Composto</label>
                <select x-model="selectedPeptideOption" @change="handlePeptideChange()" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
                    <option value="">Escolha da lista...</option>
                    <option value="Tirzepatida (Mounjaro)">Tirzepatida (Mounjaro)</option>
                    <option value="Semaglutida (Ozempic/Wegovy)">Semaglutida (Ozempic / Wegovy)</option>
                    <option value="Retatrutida">Retatrutida</option>
                    <option value="BPC-157">BPC-157</option>
                    <option value="TB-500">TB-500</option>
                    <option value="Outro">Outro (Personalizado)</option>
                </select>
            </div>
            <div x-show="selectedPeptideOption === 'Outro'">
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Nome</label>
                <input type="text" x-model="newProto.name" placeholder="Ex: PT-141" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Dose</label>
                <select x-model="newProto.dose" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white" x-show="selectedPeptideOption && selectedPeptideOption !== 'Outro' && currentDoses.length > 0">
                    <template x-for="d in currentDoses" :key="d">
                        <option :value="d" x-text="d"></option>
                    </template>
                </select>
                <input type="text" x-model="newProto.dose" placeholder="Ex: 2.5 mg" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white" x-show="!selectedPeptideOption || selectedPeptideOption === 'Outro' || currentDoses.length === 0">
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Frequência</label>
                <select x-model="newProto.frequency" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
                    <option value="Semanal">Semanal</option>
                    <option value="Diário">Diário</option>
                </select>
            </div>
            <div x-show="newProto.frequency === 'Semanal'">
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Dia da Semana</label>
                <select x-model="newProto.dayOfWeek" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
                    <option value="Domingo">Domingo</option>
                    <option value="Segunda-feira">Segunda-feira</option>
                    <option value="Terça-feira">Terça-feira</option>
                    <option value="Quarta-feira">Quarta-feira</option>
                    <option value="Quinta-feira">Quinta-feira</option>
                    <option value="Sexta-feira">Sexta-feira</option>
                    <option value="Sábado">Sábado</option>
                </select>
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Horário</label>
                <input type="time" x-model="newProto.time" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
            </div>
            <div class="flex gap-2 pt-2">
                <button @click="showProtocolModal = false" class="flex-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 py-3 rounded-xl font-medium">Cancelar</button>
                <button @click="saveProtocol()" class="flex-1 bg-indigo-600 text-white py-3 rounded-xl font-medium shadow">Salvar</button>
            </div>
        </div>
    </div>

    <!-- MODAL DE LOCAL -->
    <div x-show="showSiteModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
        <div class="bg-white dark:bg-gray-800 w-full max-w-sm p-6 rounded-3xl space-y-4 shadow-xl max-h-[90vh] overflow-y-auto">
            <h3 class="text-lg font-bold text-gray-800 dark:text-white" x-text="editingSiteIndex !== null ? 'Editar Aplicação' : 'Registrar Aplicação'"></h3>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Composto</label>
                <select x-model="newSite.compound" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
                    <option value="">Selecione...</option>
                    <template x-for="p in protocols" :key="p.name">
                        <option :value="p.name" x-text="p.name"></option>
                    </template>
                    <option value="Outro">Outro</option>
                </select>
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Data</label>
                <input type="date" x-model="newSite.date" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">1. Região</label>
                <div class="flex gap-2">
                    <button @click="newSite.mainRegion = 'Abdômen'; newSite.side = ''; newSite.quadrant = ''" :class="newSite.mainRegion === 'Abdômen' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="flex-1 py-2 rounded-lg text-sm font-medium">Abdômen</button>
                    <button @click="newSite.mainRegion = 'Braço'; newSite.side = ''; newSite.quadrant = ''" :class="newSite.mainRegion === 'Braço' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="flex-1 py-2 rounded-lg text-sm font-medium">Braço</button>
                    <button @click="newSite.mainRegion = 'Perna'; newSite.side = ''; newSite.quadrant = ''" :class="newSite.mainRegion === 'Perna' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="flex-1 py-2 rounded-lg text-sm font-medium">Perna</button>
                </div>
            </div>
            <div x-show="newSite.mainRegion">
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">2. Lado</label>
                <div class="flex gap-2">
                    <button @click="newSite.side = 'Direito'; newSite.quadrant = ''" :class="newSite.side === 'Direito' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="flex-1 py-2 rounded-lg text-sm font-medium">Direito</button>
                    <button @click="newSite.side = 'Esquerdo'; newSite.quadrant = ''" :class="newSite.side === 'Esquerdo' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="flex-1 py-2 rounded-lg text-sm font-medium">Esquerdo</button>
                </div>
            </div>
            <div x-show="newSite.mainRegion === 'Abdômen' && newSite.side">
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">3. Quadrante</label>
                <div class="grid grid-cols-2 gap-2">
                    <button @click="newSite.quadrant = 'Superior 1'" :class="newSite.quadrant === 'Superior 1' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="py-2 rounded-lg text-sm font-medium">Superior 1</button>
                    <button @click="newSite.quadrant = 'Superior 2'" :class="newSite.quadrant === 'Superior 2' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="py-2 rounded-lg text-sm font-medium">Superior 2</button>
                    <button @click="newSite.quadrant = 'Superior 3'" :class="newSite.quadrant === 'Superior 3' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="py-2 rounded-lg text-sm font-medium">Superior 3</button>
                    <button @click="newSite.quadrant = 'Superior 4'" :class="newSite.quadrant === 'Superior 4' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="py-2 rounded-lg text-sm font-medium">Superior 4</button>
                    <button @click="newSite.quadrant = 'Médio'" :class="newSite.quadrant === 'Médio' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="py-2 rounded-lg text-sm font-medium">Médio</button>
                    <button @click="newSite.quadrant = 'Inferior'" :class="newSite.quadrant === 'Inferior' ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300'" class="py-2 rounded-lg text-sm font-medium">Inferior</button>
                </div>
            </div>
            <div class="flex gap-2 pt-4 border-t dark:border-gray-700">
                <button @click="showSiteModal = false" class="flex-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 py-3 rounded-xl font-medium">Cancelar</button>
                <button @click="saveSiteLog()" class="flex-1 bg-indigo-600 text-white py-3 rounded-xl font-medium shadow">Salvar</button>
            </div>
        </div>
    </div>

    <!-- MODAL DE PROGRESSO -->
    <div x-show="showProgressModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
        <div class="bg-white dark:bg-gray-800 w-full max-w-sm p-6 rounded-3xl space-y-4 shadow-xl">
            <h3 class="text-lg font-bold text-gray-800 dark:text-white">Registar Progresso</h3>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Data</label>
                <input type="date" x-model="newProgress.date" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Peso (kg)</label>
                <input type="number" step="0.1" x-model="newProgress.weight" placeholder="Ex: 75.5" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Sintomas / Efeitos</label>
                <input type="text" x-model="newProgress.sideEffects" placeholder="Ex: Ligeira náusea" class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white">
            </div>
            <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Notas</label>
                <textarea x-model="newProgress.notes" placeholder="Observações..." class="w-full p-3 border dark:border-gray-600 rounded-xl outline-none bg-gray-50 dark:bg-gray-700 dark:text-white"></textarea>
            </div>
            <div class="flex gap-2 pt-2">
                <button @click="showProgressModal = false" class="flex-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 py-3 rounded-xl font-medium">Cancelar</button>
                <button @click="saveProgress()" class="flex-1 bg-indigo-600 text-white py-3 rounded-xl font-medium shadow">Salvar</button>
            </div>
        </div>
    </div>

    <!-- SCRIPT DA APLICAÇÃO -->
    <script>
        function peptideApp() {
            return {
                activeTab: 'calc',
                ticker: Date.now(),
                vialMg: 5,
                waterMl: 2,
                desiredMcg: 250,
                currentStockMg: 5.0,

                showProtocolModal: false,
                showSiteModal: false,
                showProgressModal: false,
                editingProtoIndex: null,
                editingSiteIndex: null,

                newProto: { name: '', dose: '', frequency: 'Semanal', dayOfWeek: 'Segunda-feira', time: '08:00' },
                newSite: { compound: '', date: '', mainRegion: '', side: '', quadrant: '' },
                newProgress: { date: '', weight: '', sideEffects: '', notes: '' },
                
                selectedPeptideOption: '',
                currentDoses: [],

                peptideDatabase: {
                    'Tirzepatida (Mounjaro)': ['2.5 mg', '5.0 mg', '7.5 mg', '10.0 mg', '12.5 mg', '15.0 mg'],
                    'Semaglutida (Ozempic/Wegovy)': ['0.25 mg', '0.5 mg', '1.0 mg', '1.7 mg', '2.4 mg'],
                    'Retatrutida': ['1.0 mg', '2.0 mg', '4.0 mg', '8.0 mg', '12.0 mg'],
                    'BPC-157': ['250 mcg', '500 mcg'],
                    'TB-500': ['2.0 mg', '5.0 mg']
                },

                protocols: [],
                siteLogs: [],
                progressLogs: [],

                initApp() {
                    this.loadData();
                    this.$watch('protocols', () => this.saveData());
                    this.$watch('siteLogs', () => this.saveData());
                    this.$watch('progressLogs', () => this.saveData());
                    this.$watch('currentStockMg', () => this.saveData());

                    setInterval(() => {
                        this.ticker = Date.now();
                    }, 30000);
                },

                saveData() {
                    const data = {
                        protocols: this.protocols,
                        siteLogs: this.siteLogs,
                        progressLogs: this.progressLogs,
                        currentStockMg: this.currentStockMg
                    };
                    localStorage.setItem('peptideManagerData', JSON.stringify(data));
                },

                loadData() {
                    const saved = localStorage.getItem('peptideManagerData');
                    if (saved) {
                        try {
                            const parsed = JSON.parse(saved);
                            this.protocols = parsed.protocols || [];
                            this.siteLogs = parsed.siteLogs || [];
                            this.progressLogs = parsed.progressLogs || [];
                            this.currentStockMg = parsed.currentStockMg || 5.0;
                        } catch (e) {
                            console.error("Erro a carregar dados", e);
                        }
                    }
                },

                exportData() {
                    const dataStr = localStorage.getItem('peptideManagerData');
                    if (!dataStr) return alert("Sem dados para exportar.");
                    const blob = new Blob([dataStr], { type: "application/json" });
                    const url = URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = `peptide-backup-${new Date().toISOString().split('T')[0]}.json`;
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    URL.revokeObjectURL(url);
                },

                formatDateBR(dateString) {
                    if (!dateString) return "";
                    const [year, month, day] = dateString.split('-');
                    return `${day}/${month}/${year}`;
                },

                get volumeNeeded() {
                    if (this.vialMg <= 0 || this.waterMl <= 0) return 0;
                    return (this.desiredMcg / ((this.vialMg * 1000) / this.waterMl));
                },
                get insulinUnits() { return this.volumeNeeded * 100; },

                deductFromStock() {
                    const doseMg = this.desiredMcg / 1000;
                    if (this.currentStockMg >= doseMg) {
                        this.currentStockMg = parseFloat((this.currentStockMg - doseMg).toFixed(2));
                    } else {
                        alert("Aviso: A dose é maior do que o restante no frasco!");
                        this.currentStockMg = 0;
                    }
                },

                resetStock() {
                    this.currentStockMg = parseFloat(this.vialMg);
                },

                handlePeptideChange() {
                    if (this.selectedPeptideOption === 'Outro') {
                        this.currentDoses = [];
                        this.newProto.name = ''; this.newProto.dose = '';
                    } else if (this.selectedPeptideOption) {
                        this.newProto.name = this.selectedPeptideOption;
                        this.currentDoses = this.peptideDatabase[this.selectedPeptideOption] || [];
                        this.newProto.dose = this.currentDoses[0] || '';
                    }
                },

                openProtocolModal(index = null) {
                    this.editingProtoIndex = index;
                    if(index !== null) {
                        const p = this.protocols[index];
                        this.newProto = JSON.parse(JSON.stringify(p));
                        if (this.peptideDatabase[p.name]) {
                            this.selectedPeptideOption = p.name;
                            this.currentDoses = this.peptideDatabase[p.name];
                        } else {
                            this.selectedPeptideOption = 'Outro';
                            this.currentDoses = [];
                        }
                    } else {
                        this.selectedPeptideOption = '';
                        this.currentDoses = [];
                        this.newProto = { name: '', dose: '', frequency: 'Semanal', dayOfWeek: 'Segunda-feira', time: '08:00' };
                    }
                    this.showProtocolModal = true;
                },

                saveProtocol() {
                    if(this.newProto.name && this.newProto.dose) {
                        if (this.editingProtoIndex !== null) {
                            this.protocols[this.editingProtoIndex] = JSON.parse(JSON.stringify(this.newProto));
                        } else {
                            this.protocols.push(JSON.parse(JSON.stringify(this.newProto)));
                        }
                        this.showProtocolModal = false;
                    }
                },

                timeUntilNext(proto) {
                    const _ = this.ticker; 
                    const now = new Date();
                    if(!proto.time) return "Horário não definido";
                    
                    const [hours, minutes] = proto.time.split(':').map(Number);
                    let target = new Date(now);
                    target.setHours(hours, minutes, 0, 0);

                    if (proto.frequency === 'Semanal') {
                        const dayMap = { 'Domingo': 0, 'Segunda-feira': 1, 'Terça-feira': 2, 'Quarta-feira': 3, 'Quinta-feira': 4, 'Sexta-feira': 5, 'Sábado': 6 };
                        const targetDay = dayMap[proto.dayOfWeek] || 0;
                        const currentDay = now.getDay();
                        let daysToWait = targetDay - currentDay;

                        if (daysToWait < 0) daysToWait += 7;
                        if (daysToWait === 0 && target <= now) daysToWait += 7;
                        
                        target.setDate(target.getDate() + daysToWait);
                    } else if (proto.frequency === 'Diário') {
                        if (target <= now) target.setDate(target.getDate() + 1);
                    }

                    const diffMs = target - now;
                    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
                    const diffHours = Math.floor((diffMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    const diffMins = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));

                    if (diffDays > 0) return `Falta(m) ${diffDays} dia(s) e ${diffHours}h`;
                    if (diffHours > 0) return `Próxima em ${diffHours}h e ${diffMins}m`;
                    if (diffMins > 0) return `Próxima em ${diffMins} min!`;
                    return "É a hora de aplicar!";
                },

                openSiteModal(index = null) {
                    this.editingSiteIndex = index;
                    if (index !== null) {
                        this.newSite = JSON.parse(JSON.stringify(this.siteLogs[index]));
                    } else {
                        const offset = new Date().getTimezoneOffset() * 60000;
                        const todayStr = new Date(Date.now() - offset).toISOString().split('T')[0];
                        this.newSite = { compound: '', date: todayStr, mainRegion: '', side: '', quadrant: '' };
                        if(this.protocols.length > 0) this.newSite.compound = this.protocols[0].name;
                    }
                    this.showSiteModal = true;
                },

                saveSiteLog() {
                    if(this.newSite.compound && this.newSite.date && this.newSite.mainRegion && this.newSite.side) {
                        let formatted = `${this.newSite.mainRegion} ${this.newSite.side}`;
                        if (this.newSite.quadrant) formatted += ` (${this.newSite.quadrant})`;

                        const logToSave = { ...this.newSite, siteFormatted: formatted };

                        if (this.editingSiteIndex !== null) this.siteLogs[this.editingSiteIndex] = logToSave;
                        else this.siteLogs.unshift(logToSave);
                        
                        this.siteLogs.sort((a, b) => new Date(b.date) - new Date(a.date));
                        this.showSiteModal = false;
                    } else {
                        alert("Preencha todos os campos obrigatórios da região.");
                    }
                },

                openProgressModal() {
                    const localNow = new Date();
                    const offset = localNow.getTimezoneOffset() * 60000;
                    const todayStr = new Date(localNow.getTime() - offset).toISOString().split('T')[0];
                    this.newProgress = { date: todayStr, weight: '', sideEffects: '', notes: '' };
                    this.showProgressModal = true;
                },

                saveProgress() {
                    if (this.newProgress.date) {
                        this.progressLogs.unshift(JSON.parse(JSON.stringify(this.newProgress)));
                        this.progressLogs.sort((a, b) => new Date(b.date) - new Date(a.date));
                        this.showProgressModal = false;
                    }
                }
            }
        }
    </script>
</body>
</html>
