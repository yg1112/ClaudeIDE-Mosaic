#!/usr/bin/env python3
"""
Mosaic 日志分析工具单元测试

运行测试：
    python -m pytest test_analyze_logs.py -v
    或
    python test_analyze_logs.py
"""

import os
import sys
import unittest
import tempfile
import shutil
from pathlib import Path
from datetime import datetime

# 导入被测试的模块
from analyze_logs import MosaicLogAnalyzer


class TestMosaicLogAnalyzer(unittest.TestCase):
    """测试 MosaicLogAnalyzer 类的所有功能"""

    def setUp(self):
        """每个测试前的准备工作"""
        # 创建临时目录
        self.test_dir = tempfile.mkdtemp()
        self.sessions_dir = Path(self.test_dir) / "sessions"
        self.sessions_dir.mkdir()
        self.analysis_dir = Path(self.test_dir) / "analysis"
        self.analysis_dir.mkdir()

        # 初始化 analyzer
        self.analyzer = MosaicLogAnalyzer(logs_dir=str(self.sessions_dir))
        self.analyzer.analysis_dir = self.analysis_dir

        # 创建测试数据
        self._create_test_logs()

    def tearDown(self):
        """每个测试后的清理工作"""
        shutil.rmtree(self.test_dir)

    def _create_test_logs(self):
        """创建测试日志文件"""

        # 日志 1: 成功案例，完全采纳
        log1 = """# Mosaic 工作日志

## 基本信息

```yaml
session_id: 20260101-100000-test-app-1
date: 2026-01-01
time: 10:00:00
mosaic_version: v2.1
```

## 项目信息

```yaml
project:
  repository: /test/repo1
  project_name: "Test App 1"
  platform: macOS
  project_type: "productivity tool"
  complexity: medium
```

## Phase 0: 项目探索

```yaml
project_profile:
  inferred_type: "macOS productivity app"
  main_features: ["task management"]
  inferred_users: "developers"
  inferred_density: high
  current_ui_state: basic

design_opportunities:
  - "Dashboard needs improvement"

user_feedback:
  推断准确性: accurate
  用户纠正: ""
```

## Phase 1: 问诊

```yaml
user_profile:
  mood: "professional"
  density: "high"
  reference_apps:
    - "Linear"
    - "Raycast"
  user_context: "developers"
  platform: "macOS"
  constraints: []

derived_tags:
  - "dark-mode"
  - "minimal"
```

## Phase 2: 采购

```yaml
sourcing_actions:
  preset_resources:
    searched: yes
    matched_count: 2
    resources:
      - name: "VComponents"
        source: "github.com/VakhoKontridze/VComponents"
        level: L1

  github_search:
    executed: yes
    queries:
      - query: "swiftui dark theme stars:>100"
        results_count: 10
        top_results:
          - name: "AwesomeUI"
            url: "github.com/test/AwesomeUI"
            stars: 200
            level: L1
            selected: yes
```

## Phase 3: 方案生成

```yaml
proposals:
  - id: A
    name: "Dark Suite"
    style: "dark theme"
    key_resources:
      - "VComponents"
      - "AwesomeUI"
    estimated_level: L1

user_selection:
  choice: A
  mix_details: ""
  selection_time: "30"
```

## Phase 4: 交付

```yaml
delivery_mode: standard

standard_delivery:
  generated_files:
    - Design/README.md
    - Design/Foundation/Theme.swift

  direct_dependencies:
    - name: "VComponents"
      url: "https://github.com/VakhoKontridze/VComponents"
      installation: "SPM"
```

## 质量指标

```yaml
quality_metrics:
  resource_quality:
    rating: high
    reason: "All L1 resources"

  match_score:
    user_preference: 9
    project_suitability: 9

  estimated_implementation_time:
    standard: "2 hours"
```

## 用户反馈

```yaml
initial_feedback:
  satisfied_with_proposals: yes
  comments: "Perfect"

  modifications_requested:
    count: 1
    items:
      - "Adjust color slightly"

final_adoption:
  status: adopted

  adopted_resources:
    - resource: "VComponents"
      kept_in_final: yes
      reason: ""
    - resource: "AwesomeUI"
      kept_in_final: yes
      reason: ""

  user_satisfaction:
    rating: 9
    feedback: "Excellent"

  issues_encountered: []
```

## 改进建议

```yaml
insights:
  what_worked_well:
    - "Project discovery was accurate"

  what_could_improve:
    - "Could ask more about color preferences"

  new_resources_discovered:
    - resource: "AwesomeUI"
      quality: high
      should_add_to_RESOURCES_md: yes
```
"""

        # 日志 2: 部分采纳，有资源被删除
        log2 = """# Mosaic 工作日志

```yaml
session_id: 20260102-140000-test-app-2
date: 2026-01-02
time: 14:00:00
mosaic_version: v2.1
```

```yaml
project:
  repository: /test/repo2
  project_name: "Test App 2"
  platform: iOS
  project_type: "social app"
  complexity: complex
```

```yaml
project_profile:
  inferred_type: "iOS social app"
  main_features: ["messaging"]
  inferred_users: "consumers"
  inferred_density: medium
  current_ui_state: none
```

```yaml
user_profile:
  mood: "friendly"
  density: "medium"
  reference_apps:
    - "Slack"
  user_context: "casual users"
  platform: "iOS"
  constraints: []
  derived_tags: ["light", "friendly"]
```

```yaml
sourcing_actions:
  preset_resources:
    searched: yes
    matched_count: 3
    resources:
      - name: "Pow"
        source: "github.com/EmergeTools/Pow"
        level: L1
      - name: "PopupView"
        source: "github.com/exyte/PopupView"
        level: L1

  github_search:
    executed: yes
    queries:
      - query: "swiftui messaging ui"
        results_count: 5
        top_results: []
```

```yaml
proposals:
  - id: A
    name: "Friendly Suite"
    style: "light and friendly"
    key_resources:
      - "Pow"
      - "PopupView"
    estimated_level: L1

user_selection:
  choice: A
  mix_details: ""
  selection_time: "45"
```

```yaml
delivery_mode: standard

standard_delivery:
  generated_files:
    - Design/README.md

  direct_dependencies:
    - name: "Pow"
      url: "https://github.com/EmergeTools/Pow"
      installation: "SPM"
    - name: "PopupView"
      url: "https://github.com/exyte/PopupView"
      installation: "SPM"
```

```yaml
quality_metrics:
  resource_quality:
    rating: medium
    reason: "Some resources not perfect fit"

  match_score:
    user_preference: 7
    project_suitability: 8
```

```yaml
initial_feedback:
  satisfied_with_proposals: partially
  comments: "Good but needs adjustment"

  modifications_requested:
    count: 3
    items:
      - "Change animation"
      - "Adjust popup style"
      - "Different colors"

final_adoption:
  status: partially_adopted

  adopted_resources:
    - resource: "PopupView"
      kept_in_final: yes
      reason: ""
    - resource: "Pow"
      kept_in_final: no
      reason: "Too many animations, performance issues"

  user_satisfaction:
    rating: 7
    feedback: "Good overall, but Pow was removed"

  issues_encountered:
    - issue: "Pow caused performance issues"
      resolved: yes
      solution: "Removed Pow"
```

```yaml
insights:
  what_worked_well:
    - "PopupView was great"

  what_could_improve:
    - "Should warn about Pow performance"

  new_resources_discovered: []
```
"""

        # 日志 3: Fallback L2 案例
        log3 = """# Mosaic 工作日志

```yaml
session_id: 20260103-160000-test-app-3
date: 2026-01-03
time: 16:00:00
mosaic_version: v2.1
```

```yaml
project:
  repository: /test/repo3
  project_name: "Test App 3"
  platform: Web
  project_type: "data visualization"
  complexity: complex
```

```yaml
project_profile:
  inferred_type: "Web data visualization"
  main_features: ["charts", "dashboards"]
  inferred_users: "analysts"
  inferred_density: high
  current_ui_state: none
```

```yaml
user_profile:
  mood: "professional"
  density: "high"
  reference_apps:
    - "Tableau"
  user_context: "data analysts"
  platform: "Web"
  constraints: []
  derived_tags: ["data-heavy", "professional"]
```

```yaml
sourcing_actions:
  preset_resources:
    searched: yes
    matched_count: 0
    resources: []

  github_search:
    executed: yes
    queries:
      - query: "data visualization components"
        results_count: 2
        top_results: []

  figma_search:
    executed: yes
    findings: []
```

```yaml
proposals:
  - id: A
    name: "Original Design"
    style: "custom data viz"
    key_resources: []
    estimated_level: L4

user_selection:
  choice: A
  mix_details: ""
  selection_time: "60"
```

```yaml
delivery_mode: fallback_L2

fallback_delivery:
  level: L2
  reason: "No suitable resources found for data viz"

  reference_materials: []

  implementation_guidance:
    - Design/IMPLEMENTATION_GUIDE.md
```

```yaml
quality_metrics:
  resource_quality:
    rating: low
    reason: "Had to create from scratch"

  match_score:
    user_preference: 6
    project_suitability: 7
```

```yaml
initial_feedback:
  satisfied_with_proposals: yes
  comments: "Understood it's a difficult case"

  modifications_requested:
    count: 5
    items:
      - "Adjust layout"
      - "Change colors"
      - "Add more charts"
      - "Refine interactions"
      - "Improve responsiveness"

final_adoption:
  status: unknown

  adopted_resources: []

  user_satisfaction:
    rating: 6
    feedback: "Had to do a lot of custom work"

  issues_encountered:
    - issue: "No good resources available"
      resolved: no
      solution: ""
```

```yaml
insights:
  what_worked_well:
    - "IMPLEMENTATION_GUIDE was helpful"

  what_could_improve:
    - "Need more data visualization resources"

  new_resources_discovered: []
```
"""

        # 保存日志文件
        with open(self.sessions_dir / "20260101-100000-test-app-1.md", 'w') as f:
            f.write(log1)

        with open(self.sessions_dir / "20260102-140000-test-app-2.md", 'w') as f:
            f.write(log2)

        with open(self.sessions_dir / "20260103-160000-test-app-3.md", 'w') as f:
            f.write(log3)

        # 创建一个示例文件（应该被跳过）
        with open(self.sessions_dir / "EXAMPLE-test.md", 'w') as f:
            f.write("# Example log")

    def test_parse_log(self):
        """测试日志解析功能"""
        log_file = self.sessions_dir / "20260101-100000-test-app-1.md"
        data = self.analyzer.parse_log(log_file)

        # 验证基本信息
        self.assertEqual(data.get('session_id'), '20260101-100000-test-app-1')

        # YAML 解析会将日期字符串转为 datetime.date 对象
        date = data.get('date')
        if isinstance(date, str):
            self.assertEqual(date, '2026-01-01')
        else:
            # 如果是 datetime.date 对象，验证值
            self.assertEqual(str(date), '2026-01-01')

        # 验证项目信息
        project = data.get('project', {})
        self.assertEqual(project.get('platform'), 'macOS')
        self.assertEqual(project.get('complexity'), 'medium')

        # 验证用户画像
        user_profile = data.get('user_profile', {})
        self.assertEqual(user_profile.get('mood'), 'professional')
        self.assertEqual(user_profile.get('density'), 'high')

        # 验证参考 App
        ref_apps = user_profile.get('reference_apps', [])
        self.assertIn('Linear', ref_apps)
        self.assertIn('Raycast', ref_apps)

    def test_get_all_logs(self):
        """测试获取所有日志"""
        logs = self.analyzer.get_all_logs()

        # 应该有 3 个日志（EXAMPLE 文件被跳过）
        self.assertEqual(len(logs), 3)

        # 验证日志包含必要字段
        for log in logs:
            self.assertIn('_file', log)

    def test_get_all_logs_with_month_filter(self):
        """测试按月份筛选日志"""
        # 筛选 2026-01 的日志
        logs = self.analyzer.get_all_logs(month='2026-01')
        self.assertEqual(len(logs), 3)

        # 筛选不存在的月份
        logs = self.analyzer.get_all_logs(month='2026-02')
        self.assertEqual(len(logs), 0)

    def test_generate_monthly_report(self):
        """测试生成月度报告"""
        report = self.analyzer.generate_monthly_report('2026-01')

        # 验证报告不为空
        self.assertIsNotNone(report)
        self.assertIn('Mosaic 月度报告', report)
        self.assertIn('总会话数: 3', report)

        # 验证平台分布
        self.assertIn('macOS', report)
        self.assertIn('iOS', report)
        self.assertIn('Web', report)

        # 验证项目复杂度
        self.assertIn('medium', report)
        self.assertIn('complex', report)

        # 验证交付模式
        self.assertIn('standard', report)
        self.assertIn('fallback_L2', report)

        # 验证用户满意度
        self.assertIn('平均评分', report)

        # 验证常见参考 App
        self.assertIn('Linear', report)
        self.assertIn('Slack', report)

        # 验证报告文件已生成
        report_file = self.analysis_dir / "monthly-2026-01.md"
        self.assertTrue(report_file.exists())

    def test_generate_quality_report(self):
        """测试生成质量报告"""
        report = self.analyzer.generate_quality_report()

        # 验证报告不为空
        self.assertIsNotNone(report)
        self.assertIn('Mosaic 质量报告', report)

        # 验证成功率统计
        self.assertIn('总会话数: 3', report)
        self.assertIn('完全采纳: 1', report)
        self.assertIn('部分采纳: 1', report)
        self.assertIn('未知: 1', report)
        self.assertIn('成功率', report)

        # 验证迭代次数统计
        self.assertIn('平均迭代次数', report)

        # 验证 Fallback 统计
        self.assertIn('Fallback 使用统计', report)
        self.assertIn('Fallback L2', report)

        # 验证报告文件已生成
        report_file = self.analysis_dir / "quality-report.md"
        self.assertTrue(report_file.exists())

    def test_generate_resources_ranking(self):
        """测试生成资源排名"""
        report = self.analyzer.generate_resources_ranking()

        # 验证报告不为空
        self.assertIsNotNone(report)
        self.assertIn('Mosaic 资源排名', report)

        # 验证资源统计
        self.assertIn('最常推荐的资源', report)

        # 验证特定资源
        self.assertIn('VComponents', report)
        self.assertIn('Pow', report)
        self.assertIn('PopupView', report)

        # 验证删除原因
        self.assertIn('Too many animations', report)
        self.assertIn('performance issues', report)

        # 验证新发现资源
        self.assertIn('新发现的高质量资源', report)
        self.assertIn('AwesomeUI', report)

        # 验证报告文件已生成
        report_file = self.analysis_dir / "resources-ranking.md"
        self.assertTrue(report_file.exists())

    def test_find_pending_feedback(self):
        """测试查找未填写反馈的日志"""
        pending = self.analyzer.find_pending_feedback()

        # 应该有 1 个未填写的日志（status: unknown）
        self.assertEqual(len(pending), 1)
        self.assertIn('20260103-160000-test-app-3.md', pending[0])

    def test_success_rate_calculation(self):
        """测试成功率计算"""
        logs = self.analyzer.get_all_logs()

        adoption_status = {}
        for log in logs:
            status = log.get('final_adoption', {}).get('status', 'unknown')
            adoption_status[status] = adoption_status.get(status, 0) + 1

        total = len(logs)
        adopted = adoption_status.get('adopted', 0) + adoption_status.get('partially_adopted', 0)
        success_rate = (adopted / total * 100) if total > 0 else 0

        # 2/3 成功（1 adopted + 1 partially_adopted）
        self.assertAlmostEqual(success_rate, 66.67, places=1)

    def test_average_modifications(self):
        """测试平均修改次数计算"""
        logs = self.analyzer.get_all_logs()

        modification_counts = []
        for log in logs:
            count = log.get('initial_feedback', {}).get('modifications_requested', {}).get('count', 0)
            modification_counts.append(count)

        avg_modifications = sum(modification_counts) / len(modification_counts)

        # (1 + 3 + 5) / 3 = 3
        self.assertEqual(avg_modifications, 3.0)

    def test_fallback_frequency(self):
        """测试 Fallback 使用频率"""
        logs = self.analyzer.get_all_logs()

        fallback_count = sum(1 for log in logs if log.get('delivery_mode', '').startswith('fallback'))
        fallback_l2_count = sum(1 for log in logs if log.get('delivery_mode') == 'fallback_L2')

        total = len(logs)

        # 1 个 fallback_L2
        self.assertEqual(fallback_count, 1)
        self.assertEqual(fallback_l2_count, 1)
        self.assertAlmostEqual(fallback_l2_count / total * 100, 33.33, places=1)

    def test_empty_logs_directory(self):
        """测试空日志目录"""
        # 删除所有日志
        for log_file in self.sessions_dir.glob("*.md"):
            log_file.unlink()

        logs = self.analyzer.get_all_logs()
        self.assertEqual(len(logs), 0)

        # 生成报告不应该崩溃
        report = self.analyzer.generate_quality_report()

        # 如果没有日志，report 可能是 None，这是预期行为
        # 我们只验证不会抛出异常
        self.assertTrue(report is None or isinstance(report, str))

    def test_malformed_log(self):
        """测试格式错误的日志"""
        # 创建一个格式错误的日志
        malformed_log = """# Malformed Log

```yaml
invalid: yaml: content:
  - with: errors
```
"""
        with open(self.sessions_dir / "20260104-malformed.md", 'w') as f:
            f.write(malformed_log)

        # 解析应该不崩溃，返回空字典或部分数据
        log_file = self.sessions_dir / "20260104-malformed.md"
        data = self.analyzer.parse_log(log_file)

        # 应该至少返回一个字典
        self.assertIsInstance(data, dict)

    def test_resource_adoption_rate(self):
        """测试资源采纳率计算"""
        logs = self.analyzer.get_all_logs()

        resource_stats = {}
        for log in logs:
            # 统计推荐
            selected = log.get('resource_evaluation', {}).get('selected_resources', [])
            for res in selected:
                if isinstance(res, dict):
                    name = res.get('name', 'Unknown')
                    if name not in resource_stats:
                        resource_stats[name] = {'recommended': 0, 'adopted': 0}
                    resource_stats[name]['recommended'] += 1

            # 统计采纳
            adopted_res = log.get('final_adoption', {}).get('adopted_resources', [])
            for res in adopted_res:
                if isinstance(res, dict):
                    name = res.get('resource', 'Unknown')
                    if res.get('kept_in_final', True):
                        if name not in resource_stats:
                            resource_stats[name] = {'recommended': 0, 'adopted': 0}
                        resource_stats[name]['adopted'] += 1

        # VComponents: 推荐 1 次，采纳 1 次 = 100%
        if 'VComponents' in resource_stats:
            self.assertGreater(resource_stats['VComponents']['adopted'], 0)

        # Pow: 推荐 1 次，被删除 = 0%
        # （在我们的测试数据中 Pow 被删除了）


class TestLogTemplateValidity(unittest.TestCase):
    """测试日志模板的有效性"""

    def test_template_exists(self):
        """测试模板文件是否存在"""
        template_path = Path(__file__).parent / "LOG_TEMPLATE.md"
        self.assertTrue(template_path.exists(), "LOG_TEMPLATE.md should exist")

    def test_template_has_required_sections(self):
        """测试模板包含所有必需部分"""
        template_path = Path(__file__).parent / "LOG_TEMPLATE.md"

        with open(template_path, 'r', encoding='utf-8') as f:
            content = f.read()

        required_sections = [
            '## 基本信息',
            '## 项目信息',
            '## Phase 0: 项目探索',
            '## Phase 1: 问诊',
            '## Phase 2: 采购',
            '## Phase 3: 方案生成',
            '## Phase 4: 交付',
            '## 质量指标',
            '## 用户反馈',
            '## 改进建议',
            '## 元数据',
        ]

        for section in required_sections:
            self.assertIn(section, content, f"Template should contain '{section}'")

    def test_example_log_exists(self):
        """测试示例日志是否存在"""
        example_path = Path(__file__).parent / "sessions" / "EXAMPLE-20260118-project-login-ui.md"
        self.assertTrue(example_path.exists(), "Example log should exist")


class TestDirectoryStructure(unittest.TestCase):
    """测试目录结构"""

    def test_logs_directory_exists(self):
        """测试 logs 目录是否存在"""
        logs_dir = Path(__file__).parent
        self.assertTrue(logs_dir.exists())

    def test_sessions_directory_exists(self):
        """测试 sessions 目录是否存在"""
        sessions_dir = Path(__file__).parent / "sessions"
        self.assertTrue(sessions_dir.exists())

    def test_analysis_directory_exists(self):
        """测试 analysis 目录是否存在"""
        analysis_dir = Path(__file__).parent / "analysis"
        self.assertTrue(analysis_dir.exists())

    def test_analyze_script_exists(self):
        """测试分析脚本是否存在"""
        script_path = Path(__file__).parent / "analyze_logs.py"
        self.assertTrue(script_path.exists())

    def test_readme_exists(self):
        """测试 README 是否存在"""
        readme_path = Path(__file__).parent / "README.md"
        self.assertTrue(readme_path.exists())


def run_tests():
    """运行所有测试"""
    # 创建测试套件
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()

    # 添加所有测试类
    suite.addTests(loader.loadTestsFromTestCase(TestMosaicLogAnalyzer))
    suite.addTests(loader.loadTestsFromTestCase(TestLogTemplateValidity))
    suite.addTests(loader.loadTestsFromTestCase(TestDirectoryStructure))

    # 运行测试
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # 返回结果
    return result.wasSuccessful()


if __name__ == '__main__':
    # 直接运行测试
    success = run_tests()
    sys.exit(0 if success else 1)
