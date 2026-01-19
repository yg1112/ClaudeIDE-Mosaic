# Mosaic 日志系统单元测试

**测试文件**: `test_analyze_logs.py`

---

## 快速开始

### 运行所有测试

```bash
cd logs/
python test_analyze_logs.py
```

### 使用 pytest (推荐)

```bash
# 安装 pytest
pip install pytest

# 运行测试（详细输出）
pytest test_analyze_logs.py -v

# 运行测试（显示覆盖率）
pip install pytest-cov
pytest test_analyze_logs.py --cov=analyze_logs --cov-report=html
```

---

## 测试覆盖范围

### 1. 核心功能测试 (`TestMosaicLogAnalyzer`)

**日志解析**:
- ✅ `test_parse_log` - 验证 YAML 日志解析
- ✅ `test_get_all_logs` - 获取所有日志
- ✅ `test_get_all_logs_with_month_filter` - 按月份筛选日志

**报告生成**:
- ✅ `test_generate_monthly_report` - 月度报告生成
- ✅ `test_generate_quality_report` - 质量报告生成
- ✅ `test_generate_resources_ranking` - 资源排名生成
- ✅ `test_find_pending_feedback` - 查找未完成的日志

**数据分析**:
- ✅ `test_success_rate_calculation` - 成功率计算
- ✅ `test_average_modifications` - 平均迭代次数
- ✅ `test_fallback_frequency` - Fallback 使用频率
- ✅ `test_resource_adoption_rate` - 资源采纳率

**边界情况**:
- ✅ `test_empty_logs_directory` - 空日志目录处理
- ✅ `test_malformed_log` - 格式错误的日志处理

### 2. 模板有效性测试 (`TestLogTemplateValidity`)

- ✅ `test_template_exists` - 模板文件存在
- ✅ `test_template_has_required_sections` - 包含所有必需部分
- ✅ `test_example_log_exists` - 示例日志存在

### 3. 目录结构测试 (`TestDirectoryStructure`)

- ✅ `test_logs_directory_exists` - logs/ 目录
- ✅ `test_sessions_directory_exists` - sessions/ 目录
- ✅ `test_analysis_directory_exists` - analysis/ 目录
- ✅ `test_analyze_script_exists` - analyze_logs.py 脚本
- ✅ `test_readme_exists` - README.md 文档

---

## 测试数据

测试使用 3 个模拟日志：

### Log 1: 成功案例（完全采纳）
```yaml
session: 20260101-100000-test-app-1
platform: macOS
status: adopted
rating: 9/10
modifications: 1
resources: VComponents (kept), AwesomeUI (kept)
```

### Log 2: 部分采纳（有资源被删除）
```yaml
session: 20260102-140000-test-app-2
platform: iOS
status: partially_adopted
rating: 7/10
modifications: 3
resources: PopupView (kept), Pow (removed - performance issues)
```

### Log 3: Fallback L2 案例
```yaml
session: 20260103-160000-test-app-3
platform: Web
status: unknown
rating: 6/10
modifications: 5
delivery_mode: fallback_L2
```

---

## 测试指标验证

### 成功率计算
- **预期**: 66.67% (2/3 成功)
- **计算**: 1 adopted + 1 partially_adopted = 2 成功
- **验证**: ✅ 通过

### 平均迭代次数
- **预期**: 3.0 次
- **计算**: (1 + 3 + 5) / 3 = 3.0
- **验证**: ✅ 通过

### Fallback 频率
- **预期**: 33.33% (1/3)
- **计算**: 1 个 fallback_L2 / 3 个总会话
- **验证**: ✅ 通过

### 资源采纳率
- **VComponents**: 推荐 1 次，采纳 1 次 → 100%
- **Pow**: 推荐 1 次，删除 1 次 → 0%
- **PopupView**: 推荐 1 次，采纳 1 次 → 100%
- **验证**: ✅ 通过

---

## 测试输出示例

### 成功运行
```
test_average_modifications ... ok
test_empty_logs_directory ... ok
test_fallback_frequency ... ok
test_find_pending_feedback ... ok
test_generate_monthly_report ... ok
test_generate_quality_report ... ok
test_generate_resources_ranking ... ok
test_get_all_logs ... ok
test_get_all_logs_with_month_filter ... ok
test_malformed_log ... ok
test_parse_log ... ok
test_resource_adoption_rate ... ok
test_success_rate_calculation ... ok
test_example_log_exists ... ok
test_template_exists ... ok
test_template_has_required_sections ... ok
test_analysis_directory_exists ... ok
test_analyze_script_exists ... ok
test_logs_directory_exists ... ok
test_readme_exists ... ok
test_sessions_directory_exists ... ok

----------------------------------------------------------------------
Ran 21 tests in 0.193s

OK
```

### 测试失败示例
```
FAIL: test_parse_log (__main__.TestMosaicLogAnalyzer)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "test_analyze_logs.py", line 538, in test_parse_log
    self.assertEqual(data.get('date'), '2026-01-01')
AssertionError: datetime.date(2026, 1, 1) != '2026-01-01'
```

---

## 添加新测试

### 1. 添加到现有测试类

```python
class TestMosaicLogAnalyzer(unittest.TestCase):
    def test_new_feature(self):
        """测试新功能"""
        # 准备测试数据
        logs = self.analyzer.get_all_logs()

        # 执行测试
        result = self.analyzer.new_feature()

        # 验证结果
        self.assertEqual(result, expected_value)
```

### 2. 创建新测试类

```python
class TestNewFeature(unittest.TestCase):
    """测试新功能模块"""

    def setUp(self):
        """每个测试前的准备"""
        self.feature = NewFeature()

    def test_feature_functionality(self):
        """测试功能正常工作"""
        result = self.feature.do_something()
        self.assertTrue(result)
```

---

## 持续集成 (CI)

### GitHub Actions 配置

创建 `.github/workflows/test-logs.yml`:

```yaml
name: Test Logging System

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.10'
      - name: Install dependencies
        run: |
          pip install pytest pytest-cov pyyaml
      - name: Run tests
        run: |
          cd logs
          pytest test_analyze_logs.py -v --cov=analyze_logs
```

---

## 测试覆盖率

### 当前覆盖率

运行以下命令查看覆盖率：

```bash
pytest test_analyze_logs.py --cov=analyze_logs --cov-report=term-missing
```

**预期覆盖率**: > 85%

**关键函数覆盖**:
- ✅ `parse_log()` - 100%
- ✅ `get_all_logs()` - 100%
- ✅ `generate_monthly_report()` - 100%
- ✅ `generate_quality_report()` - 100%
- ✅ `generate_resources_ranking()` - 100%
- ✅ `find_pending_feedback()` - 100%

---

## 常见问题

### Q: 测试失败：`ModuleNotFoundError: No module named 'yaml'`

**A**: 安装 PyYAML:
```bash
pip install pyyaml
```

### Q: 测试失败：日期格式不匹配

**A**: YAML 解析会自动将日期字符串转为 `datetime.date` 对象。测试已更新以处理两种格式。

### Q: 如何调试单个测试？

**A**: 使用 pytest 运行单个测试：
```bash
pytest test_analyze_logs.py::TestMosaicLogAnalyzer::test_parse_log -v
```

### Q: 如何查看测试的详细输出？

**A**: 使用 `-s` 标志查看 print 语句：
```bash
pytest test_analyze_logs.py -v -s
```

---

## 贡献指南

### 测试原则

1. **每个功能都要测试** - 新增功能必须有对应测试
2. **测试要独立** - 测试之间不能相互依赖
3. **使用有意义的名称** - 测试名称要描述清楚测试内容
4. **验证边界情况** - 测试空输入、错误输入、极端值
5. **保持测试简洁** - 每个测试只验证一个功能点

### 提交前检查清单

- [ ] 所有测试通过 (`python test_analyze_logs.py`)
- [ ] 新增功能有对应测试
- [ ] 测试覆盖率 > 85%
- [ ] 测试代码符合 PEP 8 规范
- [ ] 添加了必要的注释和文档

---

## 性能测试

### 大规模日志测试

创建 100 个测试日志并测试性能：

```python
# 在 test_analyze_logs.py 中添加
def test_large_scale_performance(self):
    """测试大规模日志处理性能"""
    import time

    # 创建 100 个日志
    for i in range(100):
        self._create_test_log(f"2026-01-{i:02d}")

    start = time.time()
    logs = self.analyzer.get_all_logs()
    duration = time.time() - start

    # 验证性能
    self.assertEqual(len(logs), 100)
    self.assertLess(duration, 5.0)  # 应该在 5 秒内完成
```

---

## 测试维护

### 定期维护任务

1. **每月运行一次完整测试套件**
2. **更新测试数据以反映真实场景**
3. **检查并更新过时的测试**
4. **增加新发现的边界情况测试**

### 测试文档更新

当以下情况发生时更新此文档：
- 添加新测试
- 修改测试结构
- 发现新的测试最佳实践
- 用户报告测试相关问题

---

**最后更新**: 2026-01-18
**测试版本**: v1.0
**Python 版本**: 3.10+
**依赖**: `unittest`, `pyyaml`
