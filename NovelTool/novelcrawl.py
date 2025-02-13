import requests
from bs4 import BeautifulSoup
import os
import json

# 晋江文学城小说爬取
# 请把 novel_id 以整数形式存成 json 数组，保存为同目录下的 novel_ids.json ，即可运行该代码。

def get_chapter_content(novel_id, chapter_id):
    url = f"https://www.jjwxc.net/onebook.php?novelid={novel_id}&chapterid={chapter_id}"
    response = requests.get(url)
    response.encoding = 'gbk'

    if response.status_code != 200:
        print(f"Failed to retrieve chapter {chapter_id}. Status code: {response.status_code}")
        return None, None, None

    soup = BeautifulSoup(response.text, 'html.parser')

    # 查找小说标题
    title_span = soup.find('span', class_='bigtext')
    if title_span:
        novel_title = title_span.text.strip()
    else:
        # print(f"Novel title not found.")
        novel_title = "Untitled"

    # 查找章节标题
    title_div = soup.find('div', class_='note_chapter_title')
    if title_div:
        # 提取标题
        title_tag = title_div.find('div', style='color: #707070')
        if title_tag:
            chapter_title = title_tag.text.strip()
        else:
            chapter_title = "Untitled"
    else:
        # print(f"Chapter {chapter_id} title not found.")
        chapter_title = "Untitled"

    # 查找章节内容的div，类名为'novelbody'
    content_div = soup.find('div', class_='novelbody')
    if content_div:
        # 提取文本内容
        text = ""
        start_div = content_div.find('div', style='clear:both;')
        end_div = content_div.find('div', align='right')

        for sibling in start_div.next_siblings:
            if sibling == end_div:
                break
            if sibling.name == 'br':
                text += '\n'
            elif sibling.string:
                text += sibling.string.replace('　', ' ')

        # 组合章节标题和文本内容
        content = f"{chapter_title}\n{text}"

        return novel_title, chapter_title, content
    else:
        # print(f"Chapter {chapter_id} content not found.")
        return novel_title, None


def save_chapter_content(novel_title, chapter_id, chapter_title, content, save_path):
    # 替换小说标题中的非法字符
    novel_title = novel_title.replace('/', '_').replace('\\', '_').replace(':', '_').replace('*', '_').replace('?',
                                                                                                               '_').replace(
        '"', '_').replace('<', '_').replace('>', '_').replace('|', '_')

    # 创建小说目录
    novel_path = os.path.join(save_path, novel_title)
    if not os.path.exists(novel_path):
        os.makedirs(novel_path)

    # 替换章节标题中的非法字符
    chapter_title = chapter_title.replace('/', '_').replace('\\', '_').replace(':', '_').replace('*', '_').replace('?',
                                                                                                                   '_').replace(
        '"', '_').replace('<', '_').replace('>', '_').replace('|', '_')

    # 生成章节文件路径
    file_path = os.path.join(novel_path, f'{chapter_title}_chapter_{chapter_id}.txt')

    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(content)
    print(f"Chapter {chapter_id} saved to {file_path}")


def crawl_novel(novel_id, save_path):
    chapter_id = 1
    novel_title, chapter_title, content = get_chapter_content(novel_id, chapter_id)
    if novel_title is None:
        print(f"Failed to retrieve novel {novel_id}.")
        return
    while content:
        save_chapter_content(novel_title, chapter_id, chapter_title, content, save_path)
        chapter_id += 1
        _, chapter_title, content = get_chapter_content(novel_id, chapter_id)
    print(f"Completed crawling novel {novel_id}. Total chapters: {chapter_id - 1}")


if __name__ == "__main__":
    with open('novel_ids.json', 'r') as file:
        novel_ids = json.load(file)

    # 遍历 novel_id 数组，逐个进行爬取
    for novel_id in novel_ids:
        try:
            crawl_novel(novel_id, "results")
        except Exception as e:
            print(f"An error occurred while crawling novel {novel_id}: {e}")
            continue
