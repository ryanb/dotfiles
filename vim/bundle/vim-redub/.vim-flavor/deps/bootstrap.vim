            function! s:bootstrap()
              let current_rtp = &runtimepath
              let current_rtps = split(current_rtp, ',')
              set runtimepath&
              let default_rtp = &runtimepath
              let default_rtps = split(default_rtp, ',')
              let user_dir = default_rtps[0]
              let user_after_dir = default_rtps[-1]
              let base_rtps =
              \ filter(copy(current_rtps),
              \        'v:val !=# user_dir && v:val !=# user_after_dir')
              let flavor_dirs =
              \ filter(split(glob(user_dir . '/flavors/*'), '\n'),
              \        'isdirectory(v:val)')
              let new_rtps =
              \ []
              \ + [user_dir]
              \ + flavor_dirs
              \ + base_rtps
              \ + map(reverse(copy(flavor_dirs)), 'v:val . "/after"')
              \ + [user_after_dir]
              let &runtimepath = join(new_rtps, ',')
            endfunction

            call s:bootstrap()
