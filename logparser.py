FILE='./test/logs.txt'

def parser():
    counter = {}
    with open(FILE, 'r') as f:
        for line in f:
            ip = line.split(' ')[1]
            counter[ip] = counter.get(ip, 0) + 1
    
    sorted_dict = dict(sorted(counter.items(), key=lambda item: item[1], reverse=True))

    for k, v in sorted_dict.items():
        print(v, k)

if __name__ == '__main__':
    parser()
