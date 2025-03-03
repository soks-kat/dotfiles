animation=[
'''
   ／\、 
   (`˕- ﾌ__ノ
    |、     )
    ૮し""૮しﾉ
''',
'''
    /ᐠ_^
   (^˕^ )__ノ
    |、     )
    し૮""し૮ﾉ
''',
'''
    __/\\
  <(-˕՛ )__ノ
    |、     )
    ૮し""૮しﾉ
''',
'''
    /ᐠ_^
   (^˕^ )__ノ
    |、     )
    し૮""し૮ﾉ
''']
import time
i=0
while (True):
    print("\033[H\033[J")
    print(animation[i%len(animation)])
    time.sleep(0.8)
    i+=1