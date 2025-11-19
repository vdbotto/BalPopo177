import Pkg; Pkg.add("HTTP")
import Pkg; Pkg.add("JSON")

using HTTP
using JSON

@async while true
    token = "sl.u.AGGS9mM3bUqDH_E-3ZfX-muWhRJ1uLUkQo6h2ENr3kPnhw0SV3X7OQniseFv-vmVd_XXHQjAz7iigjASmgjVjouKOVnRTrgSZyy04KlSEB5IdFjsHABPwJXT8Tg2pvs56eyVHUQ5dq7OKO0fzw41h0TbxiB1ut9BW_QJzwYefMGVICpzMeIxJU6BtAPd8cCzjFqgPnk6UdE5QFubXhD2VfiYbCd8Uk7eU__XbqerZEjRq12iJMNrRjbJNMK_3PONyG-v7Tin_p44Rig5wUTrvHtYWRxkIkLNPEILcs3JR29FMYQn9BnFx32svOs7GSizrjmJ4DtIPOkT59FE5qjeme4TIkSefp1IElT_8fg2ONF7Tqrf68VP9iaCuc7OUN1pzXuM65RUKx6VlMhhO2qyFuLkJKX41OXMgm3qVS3VVMfawq-VSnuLrmm83R7LmfGaYuIDo6Fo03NL0tML_8Kvzz5HbiPGdUN1R2fO0zzi-JEuJcGFEd5CjJPtxQZoj94qQSaa968fraBaEDz6gaRzDSKTzf5hf73aJ8KxaLhl91dmc4mv_ZSpAu2JlkoyyrfmH6BODVQNkQ0_VmrYdROl4p912O0HypNI8gUbuSn-VmJntRuF320FmMXFroD0BjyS4SsIqZwywFSRUUdxPS8UJAxizFL8oKNZ3ku0DXxFaQDqd4B946Eo3O0zTDW8d_I3WXafgj5zd7ZHICKeSW7bDrPQs_liuFI24L2A41a0LhV4QeCkP4KAatE_pidF6k--3TOdWKdpsCKLtectgQS3UgzFmj_2ELTp5kIsd-l4ARE992diIP6TLbYQBiXv8_0dEgdzE0ZmwSMxeJnCx3dpWqMC7kwrhAtohsESwMVfHN-S6jgQeJiXrl8bh1NQ12AlJqPcsHBii0AgFNMwaML0ZJmoyA7UXbS81-sk41IpkvQ4KlbkRhoj50BnXmrDJ-Z8mxbi8vgmw9eRNaFEsarUKmEmoFZz0V0W12qXcQUWAUQDhuzkQ71_A4JPU0zBQq0hd-uT8hbTvc81VhxsHPeiNvBeUk7YI1vJP-G5prlB1e0pG1F4fEH64MSmO5DneBE4u9MabBa4f9QFrO2ZeqQfAbYtKidhYBf47z0FRJmUxk9I5bDpLMhh340Kmoo5CiGyPuV0k-1AF_8wYRjDAZEl8plm78pUKfcEwowGWd1IeY6CpOhiSrWo4jZFmOPRxuSro92l371XV-MgN06KSCpa4h2_Azce-q_3VroiiM0ED2-gox9_gZRY8aDZp7pqvL6zDE6DGrkIaCVE-VEI1Ev0KBSP1N2nxXrdLhd_7EigJebw1PIcqhqBURTmPtuLjMCN71TsD9qT1iRpBKlZugZW6uH7PjBZr_ezOw3CDqlKhYZaWP_UKZ5m9lo0SI9W1m-VrL-UE0oEl4QjzT75ZdPs-mCw8ozTgU_kFRGZ_09O-dCz6-hzzMSgcV6rVcf9PPKAiaA"
    file_path = "BalPopo/registrations.csv"
    dropbox_path = "/registrations.csv"

    file_content = read(file_path)

    resp = HTTP.request("POST",
        "https://content.dropboxapi.com/2/files/upload",
        [
            "Authorization" => "Bearer " * token,
            "Dropbox-API-Arg" => JSON.json(Dict("path" => dropbox_path, "mode" => "overwrite")),
            "Content-Type" => "application/octet-stream"
        ],
        file_content
    )

    println("Upload status: ", resp.status)
    sleep(20)
end