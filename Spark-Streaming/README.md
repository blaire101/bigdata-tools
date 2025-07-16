```mermaid
flowchart TD
    A["Spark Engine / Driver"]
    B["RDD\nData: [1, 2, 3, 4, 5]"]
    C["DataFrame\nColumns: id, value\nRows:\n1, 10\n2, 20\n3, 30"]
    D["Transformation\nOperation: map(x → x * 2)\n(Lazy)"]
    E["Action\nOperation: collect()\nResult: [2, 4, 6, 8, 10]"]
    F["Result sent back to Driver"]

    A --> B
    A --> C
    B --> D
    C --> D
    D --> E
    E --> F

    %% Lazy evaluation dashed link
    D -.->|builds DAG lazily\n(no execution until Action)| E

    %% Styling classes to color key nodes
    classDef engineClass fill:#eeeeee,stroke:#333,stroke-width:1px;
    classDef rddClass fill:#e0f7fa,stroke:#006064,stroke-width:2px;
    classDef dfClass fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px;
    classDef transClass fill:#fff3e0,stroke:#e65100,stroke-width:2px;
    classDef actionClass fill:#fce4ec,stroke:#880e4f,stroke-width:2px;
    classDef resultClass fill:#ffffff,stroke:#999,stroke-width:1px,stroke-dasharray: 5 5;

    class A engineClass
    class B rddClass
    class C dfClass
    class D transClass
    class E actionClass
    class F resultClass
```
