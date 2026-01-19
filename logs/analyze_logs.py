#!/usr/bin/env python3
"""
Mosaic 日志分析工具

用途：
- 生成月度报告
- 分析推荐质量
- 资源排名
- 发现优化机会

使用：
    python analyze_logs.py --monthly 2026-01
    python analyze_logs.py --quality
    python analyze_logs.py --resources
    python analyze_logs.py --pending-feedback
"""

import os
import re
import yaml
from datetime import datetime
from collections import defaultdict, Counter
from pathlib import Path
import argparse


class MosaicLogAnalyzer:
    """Mosaic 日志分析器"""

    def __init__(self, logs_dir="./sessions"):
        self.logs_dir = Path(logs_dir)
        self.analysis_dir = Path("./analysis")
        self.analysis_dir.mkdir(exist_ok=True)

    def parse_log(self, log_file):
        """解析单个日志文件"""
        with open(log_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # 提取 YAML 代码块
        yaml_blocks = re.findall(r'```yaml\n(.*?)\n```', content, re.DOTALL)

        log_data = {}
        for block in yaml_blocks:
            try:
                data = yaml.safe_load(block)
                if data:
                    log_data.update(data)
            except yaml.YAMLError as e:
                print(f"Warning: Failed to parse YAML in {log_file}: {e}")

        return log_data

    def get_all_logs(self, month=None):
        """获取所有日志文件"""
        logs = []
        for log_file in self.logs_dir.glob("*.md"):
            # 跳过示例文件
            if log_file.name.startswith("EXAMPLE"):
                continue

            # 如果指定月份，过滤
            if month:
                # 从文件名提取日期 (YYYYMMDD)
                match = re.match(r'(\d{8})', log_file.name)
                if match:
                    log_month = match.group(1)[:6]  # YYYYMM
                    if log_month != month.replace('-', ''):
                        continue

            log_data = self.parse_log(log_file)
            log_data['_file'] = log_file.name
            logs.append(log_data)

        return logs

    def generate_monthly_report(self, month):
        """生成月度报告"""
        logs = self.get_all_logs(month)

        if not logs:
            print(f"No logs found for {month}")
            return

        report = f"# Mosaic 月度报告 - {month}\n\n"
        report += f"**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
        report += "---\n\n"

        # 基本统计
        report += "## 📊 基本统计\n\n"
        report += f"- 总会话数: {len(logs)}\n"

        # 平台分布
        platforms = Counter()
        for log in logs:
            platform = log.get('project', {}).get('platform', 'Unknown')
            platforms[platform] += 1

        report += f"\n### 平台分布\n\n"
        for platform, count in platforms.most_common():
            report += f"- {platform}: {count}\n"

        # 项目复杂度
        complexity = Counter()
        for log in logs:
            comp = log.get('project', {}).get('complexity', 'Unknown')
            complexity[comp] += 1

        report += f"\n### 项目复杂度\n\n"
        for comp, count in complexity.most_common():
            report += f"- {comp}: {count}\n"

        # 交付模式
        delivery_modes = Counter()
        for log in logs:
            mode = log.get('delivery_mode', 'Unknown')
            delivery_modes[mode] += 1

        report += f"\n### 交付模式\n\n"
        for mode, count in delivery_modes.most_common():
            report += f"- {mode}: {count}\n"

        # 用户满意度
        ratings = []
        for log in logs:
            rating = log.get('final_adoption', {}).get('user_satisfaction', {}).get('rating')
            if rating:
                ratings.append(rating)

        if ratings:
            avg_rating = sum(ratings) / len(ratings)
            report += f"\n### 用户满意度\n\n"
            report += f"- 平均评分: {avg_rating:.1f}/10\n"
            report += f"- 评分样本数: {len(ratings)}\n"
            report += f"- 最高评分: {max(ratings)}\n"
            report += f"- 最低评分: {min(ratings)}\n"

        # 常见参考 App
        ref_apps = Counter()
        for log in logs:
            apps = log.get('user_profile', {}).get('reference_apps', [])
            for app in apps:
                ref_apps[app] += 1

        report += f"\n### 最常被参考的 App (Top 10)\n\n"
        for app, count in ref_apps.most_common(10):
            report += f"- {app}: {count} 次\n"

        # 保存报告
        report_file = self.analysis_dir / f"monthly-{month}.md"
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report)

        print(f"✅ 月度报告已生成: {report_file}")
        return report

    def generate_quality_report(self):
        """生成质量报告"""
        logs = self.get_all_logs()

        if not logs:
            print("No logs found")
            return

        report = f"# Mosaic 质量报告\n\n"
        report += f"**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
        report += "---\n\n"

        # 成功率统计
        adoption_status = Counter()
        for log in logs:
            status = log.get('final_adoption', {}).get('status', 'unknown')
            adoption_status[status] += 1

        total = len(logs)
        adopted = adoption_status.get('adopted', 0) + adoption_status.get('partially_adopted', 0)
        success_rate = (adopted / total * 100) if total > 0 else 0

        report += "## 📈 成功率统计\n\n"
        report += f"- 总会话数: {total}\n"
        report += f"- 完全采纳: {adoption_status.get('adopted', 0)}\n"
        report += f"- 部分采纳: {adoption_status.get('partially_adopted', 0)}\n"
        report += f"- 拒绝: {adoption_status.get('rejected', 0)}\n"
        report += f"- 未知: {adoption_status.get('unknown', 0)}\n"
        report += f"- **成功率**: {success_rate:.1f}%\n\n"

        # 评价成功率
        if success_rate >= 80:
            report += "✅ **评价**: 优秀，继续保持！\n"
        elif success_rate >= 60:
            report += "⚠️ **评价**: 良好，但有改进空间。\n"
        else:
            report += "❌ **评价**: 需要改进，请检查推荐质量和问诊流程。\n"

        # 迭代次数统计
        modification_counts = []
        for log in logs:
            count = log.get('initial_feedback', {}).get('modifications_requested', {}).get('count', 0)
            modification_counts.append(count)

        if modification_counts:
            avg_modifications = sum(modification_counts) / len(modification_counts)
            report += f"\n## 🔄 迭代次数统计\n\n"
            report += f"- 平均迭代次数: {avg_modifications:.1f}\n"
            report += f"- 最多迭代: {max(modification_counts)}\n"
            report += f"- 无需修改: {modification_counts.count(0)}\n\n"

            if avg_modifications < 2:
                report += "✅ **评价**: 很好，问诊质量高。\n"
            elif avg_modifications < 3:
                report += "⚠️ **评价**: 可以接受，但可以改进问诊流程。\n"
            else:
                report += "❌ **评价**: 迭代次数过多，需要改进问诊深度。\n"

        # Fallback 使用频率
        fallback_count = sum(1 for log in logs if log.get('delivery_mode', '').startswith('fallback'))
        fallback_l2_count = sum(1 for log in logs if log.get('delivery_mode') == 'fallback_L2')

        report += f"\n## 🆘 Fallback 使用统计\n\n"
        report += f"- Fallback 使用次数: {fallback_count} ({fallback_count/total*100:.1f}%)\n"
        report += f"- Fallback L2 使用次数: {fallback_l2_count} ({fallback_l2_count/total*100:.1f}%)\n\n"

        if fallback_l2_count / total > 0.15:
            report += "⚠️ **警告**: Fallback L2 使用率过高，需要补充更多资源到 RESOURCES.md\n"

        # 常见被删除的资源
        removed_resources = Counter()
        for log in logs:
            resources = log.get('final_adoption', {}).get('adopted_resources', [])
            for res in resources:
                if isinstance(res, dict) and not res.get('kept_in_final', True):
                    resource_name = res.get('resource', 'Unknown')
                    reason = res.get('reason', 'No reason')
                    removed_resources[f"{resource_name} ({reason})"] += 1

        if removed_resources:
            report += f"\n## ⚠️ 常被删除的资源 (Top 10)\n\n"
            for resource, count in removed_resources.most_common(10):
                report += f"- {resource}: {count} 次\n"
            report += "\n**建议**: 考虑从 RESOURCES.md 中移除这些资源\n"

        # 保存报告
        report_file = self.analysis_dir / "quality-report.md"
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report)

        print(f"✅ 质量报告已生成: {report_file}")
        return report

    def generate_resources_ranking(self):
        """生成资源排名"""
        logs = self.get_all_logs()

        if not logs:
            print("No logs found")
            return

        report = f"# Mosaic 资源排名\n\n"
        report += f"**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
        report += "---\n\n"

        # 统计资源推荐和采纳情况
        resource_stats = defaultdict(lambda: {
            'recommended': 0,
            'adopted': 0,
            'removed': 0,
            'removal_reasons': []
        })

        for log in logs:
            # 统计推荐的资源
            selected = log.get('resource_evaluation', {}).get('selected_resources', [])
            for res in selected:
                if isinstance(res, dict):
                    name = res.get('name', 'Unknown')
                    resource_stats[name]['recommended'] += 1

            # 统计采纳情况
            adopted_res = log.get('final_adoption', {}).get('adopted_resources', [])
            for res in adopted_res:
                if isinstance(res, dict):
                    name = res.get('resource', 'Unknown')
                    if res.get('kept_in_final', True):
                        resource_stats[name]['adopted'] += 1
                    else:
                        resource_stats[name]['removed'] += 1
                        reason = res.get('reason', 'No reason')
                        resource_stats[name]['removal_reasons'].append(reason)

        # 生成推荐排名
        report += "## 📊 最常推荐的资源 (Top 20)\n\n"
        sorted_resources = sorted(
            resource_stats.items(),
            key=lambda x: x[1]['recommended'],
            reverse=True
        )[:20]

        for name, stats in sorted_resources:
            report += f"### {name}\n\n"
            report += f"- 推荐次数: {stats['recommended']}\n"
            report += f"- 采纳次数: {stats['adopted']}\n"
            report += f"- 被删除次数: {stats['removed']}\n"

            if stats['recommended'] > 0:
                adoption_rate = stats['adopted'] / stats['recommended'] * 100
                report += f"- 采纳率: {adoption_rate:.1f}%\n"

                if adoption_rate >= 80:
                    report += "- ✅ **评价**: 高质量资源\n"
                elif adoption_rate >= 50:
                    report += "- ⚠️ **评价**: 中等质量\n"
                else:
                    report += "- ❌ **评价**: 低质量，考虑移除\n"

            if stats['removal_reasons']:
                report += f"- 删除原因: {', '.join(set(stats['removal_reasons']))}\n"

            report += "\n"

        # 新发现的高质量资源
        new_resources = []
        for log in logs:
            discovered = log.get('insights', {}).get('new_resources_discovered', [])
            for res in discovered:
                if isinstance(res, dict) and res.get('should_add_to_RESOURCES_md'):
                    new_resources.append(res)

        if new_resources:
            report += "## 🆕 新发现的高质量资源\n\n"
            for res in new_resources:
                report += f"- **{res.get('resource', 'Unknown')}**: {res.get('quality', 'Unknown')} quality\n"
            report += "\n**建议**: 将这些资源添加到 RESOURCES.md\n"

        # 保存报告
        report_file = self.analysis_dir / "resources-ranking.md"
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report)

        print(f"✅ 资源排名已生成: {report_file}")
        return report

    def find_pending_feedback(self):
        """查找未填写最终反馈的日志"""
        logs = self.get_all_logs()

        pending = []
        for log in logs:
            status = log.get('final_adoption', {}).get('status')
            if not status or status == 'unknown':
                pending.append(log.get('_file', 'Unknown'))

        print(f"\n📋 未填写最终反馈的日志: {len(pending)}\n")
        for file in pending:
            print(f"- {file}")

        return pending


def main():
    parser = argparse.ArgumentParser(description='Mosaic 日志分析工具')
    parser.add_argument('--monthly', type=str, help='生成月度报告，格式: YYYY-MM')
    parser.add_argument('--quality', action='store_true', help='生成质量报告')
    parser.add_argument('--resources', action='store_true', help='生成资源排名')
    parser.add_argument('--pending-feedback', action='store_true', help='查看未填写反馈的日志')

    args = parser.parse_args()

    analyzer = MosaicLogAnalyzer()

    if args.monthly:
        analyzer.generate_monthly_report(args.monthly)
    elif args.quality:
        analyzer.generate_quality_report()
    elif args.resources:
        analyzer.generate_resources_ranking()
    elif args.pending_feedback:
        analyzer.find_pending_feedback()
    else:
        # 默认生成所有报告
        print("生成所有报告...\n")
        analyzer.generate_quality_report()
        analyzer.generate_resources_ranking()
        analyzer.find_pending_feedback()


if __name__ == '__main__':
    main()
