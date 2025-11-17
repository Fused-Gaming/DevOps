# Navigation Flow Diagram

This document visualizes the complete navigation flow of the Claude Agent Prompts Integration Tool.

## Main Menu Navigation Flow

```mermaid
flowchart TD
    Start([Launch integrate.js]) --> Welcome[Welcome Screen<br/>Version 1.1.0]
    Welcome --> MainMenu{Main Menu<br/>7 Options}

    %% Option 1: Browse Categories
    MainMenu -->|1. Browse Categories 📚| BrowseMenu[Browse Categories Menu<br/>9 Categories + Back]
    BrowseMenu -->|Select Category| ViewCategory[View Category<br/>List All Agents]
    BrowseMenu -->|Back| MainMenu
    ViewCategory -->|Select Agent| ViewAgent1[View Agent Details<br/>Metadata + Content Preview]
    ViewCategory -->|Back| BrowseMenu
    ViewAgent1 -->|Toggle Selection| ViewAgent1
    ViewAgent1 -->|Back| ViewCategory
    ViewAgent1 -->|Return to Categories| BrowseMenu
    ViewAgent1 -->|Main Menu| MainMenu

    %% Option 2: Search Agents
    MainMenu -->|2. Search Agents 🔍| SearchPrompt[Enter Search Keyword]
    SearchPrompt -->|Submit Query| SearchResults{Search Results}
    SearchResults -->|Results Found| DisplayResults[Display Matching Agents<br/>With Highlights]
    SearchResults -->|No Results| NoResults[No Matches Found]
    NoResults -->|Try Again| SearchPrompt
    NoResults -->|Back| MainMenu
    DisplayResults -->|Select Agent| ViewAgent2[View Agent Details]
    DisplayResults -->|Back| MainMenu
    ViewAgent2 -->|Toggle Selection| ViewAgent2
    ViewAgent2 -->|Back to Results| DisplayResults
    ViewAgent2 -->|Main Menu| MainMenu

    %% Option 3: View Selected
    MainMenu -->|3. View Selected 📋| CheckSelected{Any Agents<br/>Selected?}
    CheckSelected -->|No| EmptySelected[No Agents Selected<br/>Prompt to Browse/Search]
    CheckSelected -->|Yes| SelectedList[List Selected Agents<br/>With Details]
    EmptySelected -->|Back| MainMenu
    SelectedList -->|View Agent Details| ViewAgent3[View Agent Details]
    SelectedList -->|Clear All| ClearConfirm{Confirm Clear?}
    SelectedList -->|Integrate Now| IntegrateFlow
    SelectedList -->|Back| MainMenu
    ClearConfirm -->|Yes| Cleared[All Selections Cleared]
    ClearConfirm -->|No| SelectedList
    Cleared -->|Back| MainMenu
    ViewAgent3 -->|Toggle Selection| ViewAgent3
    ViewAgent3 -->|Back| SelectedList

    %% Option 4: Integrate Into Project
    MainMenu -->|4. Integrate Into Project 🚀| IntegrateFlow[Integration Workflow]
    IntegrateFlow --> CheckSelection{Agents<br/>Selected?}
    CheckSelection -->|No| PromptSelect[Prompt to Select Agents]
    CheckSelection -->|Yes| ChooseMethod{Choose Integration<br/>Method}
    PromptSelect -->|Browse| BrowseMenu
    PromptSelect -->|Search| SearchPrompt
    PromptSelect -->|Cancel| MainMenu
    ChooseMethod -->|Copy Files| TargetDir[Enter Target Directory]
    ChooseMethod -->|Generate Script| ScriptName[Enter Script Name]
    ChooseMethod -->|Cancel| MainMenu
    TargetDir -->|Confirm| ExecuteCopy[Execute File Copy<br/>With Progress]
    ScriptName -->|Confirm| GenerateScript[Generate Shell Script]
    ExecuteCopy -->|Success| IntegrateSuccess[Integration Successful<br/>Summary Display]
    ExecuteCopy -->|Error| IntegrateError[Error Display<br/>Retry Options]
    GenerateScript -->|Success| ScriptSuccess[Script Generated<br/>Usage Instructions]
    IntegrateSuccess -->|Main Menu| MainMenu
    IntegrateError -->|Retry| IntegrateFlow
    IntegrateError -->|Cancel| MainMenu
    ScriptSuccess -->|Main Menu| MainMenu

    %% Option 5: Quick Presets
    MainMenu -->|5. Quick Presets ⚡| PresetsMenu{Choose Preset}
    PresetsMenu -->|Full-Stack 🌐| PresetFullStack[4 Agents Selected<br/>coder, tester, reviewer, planner]
    PresetsMenu -->|GitHub 🐙| PresetGitHub[4 Agents Selected<br/>pr-manager, code-review, issue-tracker, ci-cd]
    PresetsMenu -->|Code Quality ✨| PresetQuality[4 Agents Selected<br/>tester, reviewer, analyzer, monitor]
    PresetsMenu -->|SPARC ⚡| PresetSPARC[4 Agents Selected<br/>specification, pseudocode, architecture, refinement]
    PresetsMenu -->|Swarm 🐝| PresetSwarm[3 Agents Selected<br/>queen, collective, hierarchical]
    PresetsMenu -->|Back| MainMenu
    PresetFullStack --> PresetConfirm{Integrate Now?}
    PresetGitHub --> PresetConfirm
    PresetQuality --> PresetConfirm
    PresetSPARC --> PresetConfirm
    PresetSwarm --> PresetConfirm
    PresetConfirm -->|Yes| IntegrateFlow
    PresetConfirm -->|View Selected| SelectedList
    PresetConfirm -->|Back| PresetsMenu

    %% Option 6: About
    MainMenu -->|6. About ℹ️| AboutScreen[About Screen<br/>Version, Stats, Links]
    AboutScreen -->|Back| MainMenu

    %% Option 7: Support (NEW)
    MainMenu -->|7. Support This Project 💝| SupportScreen[Donation Information<br/>Solana Address<br/>Solscan Link]
    SupportScreen -->|Back| MainMenu

    %% Exit
    MainMenu -->|Exit/Ctrl+C| Exit([Exit Program])

    style Start fill:#4CAF50,stroke:#2E7D32,color:#fff
    style Exit fill:#f44336,stroke:#c62828,color:#fff
    style MainMenu fill:#2196F3,stroke:#1565C0,color:#fff
    style IntegrateSuccess fill:#4CAF50,stroke:#2E7D32,color:#fff
    style ScriptSuccess fill:#4CAF50,stroke:#2E7D32,color:#fff
    style IntegrateError fill:#f44336,stroke:#c62828,color:#fff
    style SupportScreen fill:#9C27B0,stroke:#6A1B9A,color:#fff
```

## Breadcrumb Trail Examples

```mermaid
flowchart LR
    subgraph "Browse Flow"
        B1[Home] --> B2[Browse Categories]
        B2 --> B3[Core Development]
        B3 --> B4[coder]
    end

    subgraph "Search Flow"
        S1[Home] --> S2[Search]
        S2 --> S3[Results: 'test']
        S3 --> S4[tester]
    end

    subgraph "Integration Flow"
        I1[Home] --> I2[Integrate]
        I2 --> I3[Choose Method]
        I3 --> I4[Success]
    end

    subgraph "Preset Flow"
        P1[Home] --> P2[Quick Presets]
        P2 --> P3[Full-Stack]
        P3 --> P4[Integrate]
    end
```

## Category Structure

```mermaid
flowchart TD
    Categories[9 Main Categories]

    Categories --> Core[💻 Core Development<br/>5 Agents]
    Categories --> GitHub[🐙 GitHub Integration<br/>13 Agents]
    Categories --> Hive[👑 Hive-Mind<br/>5 Agents]
    Categories --> Swarm[🐝 Swarm Coordination<br/>3 Agents]
    Categories --> SPARC[⚡ SPARC Methodology<br/>4 Agents]
    Categories --> Optimization[🚀 Optimization<br/>5 Agents]
    Categories --> Testing[✅ Testing<br/>2 Agents]
    Categories --> DevOps[⚙️ DevOps<br/>1 Agent]
    Categories --> Analysis[🔍 Analysis<br/>2 Agents]

    Core --> C1[coder]
    Core --> C2[planner]
    Core --> C3[researcher]
    Core --> C4[reviewer]
    Core --> C5[tester]

    GitHub --> G1[pr-manager]
    GitHub --> G2[code-review-swarm]
    GitHub --> G3[issue-tracker]
    GitHub --> G4[And 10 more...]

    style Categories fill:#FF6B35,stroke:#C44D2C,color:#fff
    style Core fill:#4ECDC4,stroke:#3BA99C,color:#fff
    style GitHub fill:#95E1D3,stroke:#6FB8A9,color:#000
    style Hive fill:#F38181,stroke:#D55555,color:#fff
```

## User Journey Scenarios

### Scenario 1: Browse and Select Specific Agents

```mermaid
sequenceDiagram
    participant U as User
    participant M as Main Menu
    participant B as Browse
    participant C as Category View
    participant A as Agent View

    U->>M: Launch integrate.js
    M->>U: Display 7 options
    U->>M: Select "Browse Categories"
    M->>B: Navigate to Browse
    B->>U: Show 9 categories
    U->>B: Select "Core Development"
    B->>C: Load category
    C->>U: Show 5 agents
    U->>C: Select "coder"
    C->>A: Display agent details
    A->>U: Show metadata + preview
    U->>A: Toggle selection (✓)
    A->>U: Agent selected
    U->>A: Back to category
    A->>C: Return
    U->>C: Select "tester"
    C->>A: Display agent details
    U->>A: Toggle selection (✓)
    U->>A: Main Menu
    A->>M: Return to main
    U->>M: Select "Integrate"
    M->>U: Success!
```

### Scenario 2: Quick Preset Integration

```mermaid
sequenceDiagram
    participant U as User
    participant M as Main Menu
    participant P as Presets
    participant I as Integration

    U->>M: Launch integrate.js
    M->>U: Display 7 options
    U->>M: Select "Quick Presets"
    M->>P: Navigate to presets
    P->>U: Show 5 preset options
    U->>P: Select "Full-Stack"
    P->>U: 4 agents auto-selected
    U->>P: Confirm "Integrate Now"
    P->>I: Start integration
    I->>U: Choose method
    U->>I: Select "Copy Files"
    I->>U: Enter target directory
    U->>I: ".claude/agents"
    I->>U: Copying files... (progress)
    I->>U: Success! 4 agents integrated
    I->>M: Return to main menu
```

### Scenario 3: Search and Integrate

```mermaid
sequenceDiagram
    participant U as User
    participant M as Main Menu
    participant S as Search
    participant R as Results
    participant A as Agent View
    participant I as Integration

    U->>M: Launch integrate.js
    U->>M: Select "Search Agents"
    M->>S: Navigate to search
    S->>U: Enter keyword prompt
    U->>S: Type "github"
    S->>R: Execute search
    R->>U: Display 13 matching agents
    U->>R: Select "pr-manager"
    R->>A: Show agent details
    U->>A: Toggle selection (✓)
    U->>A: Back to results
    A->>R: Return
    U->>R: Select "code-review-swarm"
    R->>A: Show agent details
    U->>A: Toggle selection (✓)
    U->>A: Main Menu
    A->>M: Return
    U->>M: Select "View Selected"
    M->>U: Show 2 selected agents
    U->>M: Select "Integrate Now"
    M->>I: Start integration
    I->>U: Generate script option
    U->>I: "integrate-github.sh"
    I->>U: Script generated!
```

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Welcome
    Welcome --> MainMenu

    state MainMenu {
        [*] --> Idle
        Idle --> BrowseSelected
        Idle --> SearchSelected
        Idle --> ViewSelectedSelected
        Idle --> IntegrateSelected
        Idle --> PresetsSelected
        Idle --> AboutSelected
        Idle --> SupportSelected
    }

    BrowseSelected --> BrowseCategories
    state BrowseCategories {
        [*] --> CategoryList
        CategoryList --> ViewCategory
        ViewCategory --> ViewAgent
        ViewAgent --> AgentSelected: Toggle
        AgentSelected --> ViewAgent
        ViewAgent --> ViewCategory: Back
        ViewCategory --> CategoryList: Back
    }
    BrowseCategories --> MainMenu: Done

    SearchSelected --> SearchAgents
    state SearchAgents {
        [*] --> EnterQuery
        EnterQuery --> ShowResults
        ShowResults --> ViewSearchAgent
        ViewSearchAgent --> AgentSelectedSearch: Toggle
        AgentSelectedSearch --> ViewSearchAgent
        ViewSearchAgent --> ShowResults: Back
    }
    SearchAgents --> MainMenu: Done

    ViewSelectedSelected --> ViewSelected
    state ViewSelected {
        [*] --> ListSelected
        ListSelected --> ViewSelectedAgent
        ListSelected --> ClearAll
        ClearAll --> ListSelected
        ViewSelectedAgent --> ListSelected: Back
    }
    ViewSelected --> MainMenu: Done

    IntegrateSelected --> Integration
    state Integration {
        [*] --> CheckIfSelected
        CheckIfSelected --> PromptToSelect: None
        PromptToSelect --> [*]
        CheckIfSelected --> ChooseIntegrationMethod: Has Selection
        ChooseIntegrationMethod --> CopyFiles
        ChooseIntegrationMethod --> GenerateScript
        CopyFiles --> IntegrationComplete
        GenerateScript --> IntegrationComplete
        IntegrationComplete --> [*]
    }
    Integration --> MainMenu: Done

    PresetsSelected --> QuickPresets
    state QuickPresets {
        [*] --> PresetList
        PresetList --> PresetChosen
        PresetChosen --> AgentsAutoSelected
        AgentsAutoSelected --> ConfirmIntegrate
    }
    QuickPresets --> Integration: Integrate
    QuickPresets --> MainMenu: Back

    AboutSelected --> About
    About --> MainMenu: Back

    SupportSelected --> Support
    Support --> MainMenu: Back

    MainMenu --> [*]: Exit
```

## Selection State Flow

```mermaid
flowchart TD
    Start([User Launches Tool]) --> NoSelection[No Agents Selected<br/>selectedAgents = empty]

    NoSelection -->|Browse/Search| ViewAgent[View Agent Details]
    ViewAgent -->|Press Space/Enter| ToggleSelection{Currently<br/>Selected?}

    ToggleSelection -->|No| AddToSelection[Add to selectedAgents<br/>Show ✓ indicator]
    ToggleSelection -->|Yes| RemoveFromSelection[Remove from selectedAgents<br/>Show empty indicator]

    AddToSelection --> HasSelection[Has Selection<br/>selectedAgents.length > 0]
    RemoveFromSelection --> CheckCount{Any agents<br/>still selected?}

    CheckCount -->|Yes| HasSelection
    CheckCount -->|No| NoSelection

    HasSelection -->|View Selected| DisplayList[Display Selected List<br/>With Details]
    HasSelection -->|Quick Preset| ReplaceSelection[Replace with Preset Agents]
    HasSelection -->|Clear All| ConfirmClear{Confirm?}

    ReplaceSelection --> HasSelection
    ConfirmClear -->|Yes| NoSelection
    ConfirmClear -->|No| HasSelection

    DisplayList -->|Integrate| Integration[Start Integration Workflow]
    Integration --> Success[Integration Complete<br/>Keep Selection]

    Success --> HasSelection

    style NoSelection fill:#FFF3E0,stroke:#F57C00
    style HasSelection fill:#E8F5E9,stroke:#388E3C
    style Success fill:#4CAF50,stroke:#2E7D32,color:#fff
```

## Key Navigation Shortcuts

| From State | Shortcut | Action |
|------------|----------|--------|
| Any View | `Ctrl+C` | Exit program |
| Category/Results | `↑/↓` | Navigate list |
| Agent View | `Space/Enter` | Toggle selection |
| Agent View | `b` | Back to previous |
| Agent View | `m` | Main menu |
| Any Menu | `q` | Quit/Back |
| Search Results | `n` | New search |

## Navigation Tips

1. **Breadcrumbs**: Always visible at top showing current location
2. **Selection Counter**: Shows "X agents selected" in header
3. **Visual Indicators**:
   - `✓` = Selected agent
   - `○` = Unselected agent
   - `→` = Current menu item
4. **Loading States**: Spinner animation during operations
5. **Color Coding**: Each category has unique color
6. **Progress Tracking**: Real-time feedback during integration

---

**Tool Version:** 1.1.0
**Total Menu Options:** 7
**Total Navigation Paths:** 20+
**Max Depth:** 4 levels (Home → Browse → Category → Agent)
