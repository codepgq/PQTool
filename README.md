# PQTool

# `carthage`
```
github "codepgq/PQTool"
```

一些常用的东西的封装


# 已知按钮可能存在的问题
`PQButton` 在`iOS 13`系统中，使用`SnapKit`为按钮布局，并未设置`width/height`，修改了按钮的状态之后，导致`UI`卡死问题

可以使用`SnapKit`为按钮指定`width/height`解决
