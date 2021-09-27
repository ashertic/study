import sys
from expert_api_base import ExpertApiRequest
import os
import json
import time

if __name__ == '__main__':
    dir_path = os.path.dirname(os.path.realpath(__file__))
    args = sys.argv
    test_package_name = args[1]
    # test_config_name = None
    test_config_name = args[2]
    if not test_config_name:
        test_config_name = 'test_config.json'
    test_package_path = os.path.join(dir_path, test_package_name)
    test_config_file_path = os.path.join(test_package_path, test_config_name)

    detail_output = True

    with open(test_config_file_path) as json_file:
        test_configs = json.load(json_file)

    endpoint = test_configs['endpoint']
    expert_apis = test_configs['expert_apis']
    print(f"将对api服务 {endpoint} 进行批量测试, 受测试能手api共 {len(expert_apis)} 个")

    total_test_file_count = 0
    api_level_results = []
    for index, expert_api_config in enumerate(expert_apis):
        workspace_name = expert_api_config['workspace_name']
        test_folder = expert_api_config['test_folder']
        samples_root = f'{test_package_path}/{test_folder}'
        module = ExpertApiRequest(endpoint=endpoint, expert_api_config=expert_api_config)
        test_files = []
        api_test_results = []
        for filename in os.listdir(samples_root):
            filepath = os.path.join(samples_root, filename)
            test_files.append({
                'filename': filename,
                'filepath': filepath
            })

        print(f'\t将测试第 {index + 1} 个 api: {workspace_name}, 受测试文件共 {len(test_files)} 份')

        total_test_file_count = len(test_files)
        for file_index, file in enumerate(test_files):
            result = None
            try:
                time1 = time.time()
                result = module.api(endpoint, expert_api_config, file['filepath'], detail_output=detail_output)
                time2 = time.time()
                time_cost = time2 - time1
            except:
                result = None
                time_cost = 0

            if result is not None:
                api_test_results.append({'file_index': file_index + 1, 'file_name': file, 'success': True})
                print(
                    f'\t总共{total_test_file_count}份文件, 当前测试第{file_index + 1}个文件, {file["filename"]}, 测试通过, 耗时{time_cost}秒')
            else:
                api_test_results.append({'file_index': file_index + 1, 'file_name': file, 'success': False})
                print(
                    f'\t总共{total_test_file_count}份文件, 当前测试第{file_index + 1}个文件, {file["filename"]}, 测试不通过, 耗时{time_cost}秒')

        print('\n' + '-' * 30 + 'API TEST REPORT' + '-' * 30)
        success_count = len([i for i in api_test_results if i['success']])
        failed_count = total_test_file_count - success_count
        success_rate = success_count / total_test_file_count * 100
        print(f'\t第 {index + 1} 个 api: {workspace_name}, 受测试文件共 {total_test_file_count} 份')
        print(f'\t其中 {success_count} 份测试通过, {failed_count} 份测试未通过, 通过率为 {success_rate}%')
        api_level_results.append(
            {'api': workspace_name, 'success': success_count, 'failed': failed_count, 'success_rate': success_rate})
        print('-' * 30 + 'API TEST REPORT' + '-' * 30 + '\n')

    print('*' * 50 + 'API BATCH TEST REPORT' + '-' * 50)
    for i in api_level_results:
        print(i)
    print('*' * 50 + 'API BATCH TEST REPORT' + '-' * 50)

