flowchart TD
    A["Spark Engine / Driver"]
    B["RDD<br/>Data: [1, 2, 3, 4, 5]"]
    C["DataFrame<br/>Columns: id, value<br/>Rows:<br/>1, 10<br/>2, 20<br/>3, 30"]
    D["Transformation<br/>Operation: map(x → x * 2)<br/>(Lazy)"]
    E["Action<br/>Operation: collect()<br/>Result: [2, 4, 6, 8, 10]"]
    F["Result sent back to Driver"]

    A --> B
    A --> C
    B --> D
    C --> D
    D --> E
    E --> F

    note right of D: builds DAG lazily<br/>no execution until Action

    style A fill:#eeeeee,stroke:#333,stroke-width:2px
    style B fill:#e0f7fa,stroke:#006064,stroke-width:2px
    style C fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    style D fill:#fff3e0,stroke:#e65100,stroke-width:2px
    style E fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    style F fill:#ffffff,stroke:#999,stroke-width:2px
    
